#!/usr/bin/env bash
# Creates the 3 Venn Concierge Pilot cron jobs on the isolated `venn` hermes
# profile. Run once, after: profile exists, Google OAuth is authenticated on
# the venn profile, Telegram delivery is configured, and the onboarding
# interview has seeded memory.
#
# Safe to re-run: each `hermes cron create` call makes a new job, so if you
# need to change a schedule/prompt, remove the old job first with
# `hermes -p venn cron remove <job_id>` (see: hermes -p venn cron list).

set -euo pipefail

PROMPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/prompts" && pwd)"
PROFILE="venn"

# --- Preflight -----------------------------------------------------------
if ! command -v hermes >/dev/null 2>&1; then
  echo "ERROR: 'hermes' not on PATH. Run from the hermes repo with 'uv run hermes ...'" >&2
  exit 1
fi

if hermes profile show "$PROFILE" 2>&1 | grep -q "does not exist"; then
  echo "ERROR: profile '$PROFILE' does not exist yet. Run: hermes profile create $PROFILE" >&2
  exit 1
fi

if hermes -p "$PROFILE" cron list 2>&1 | grep -q "venn-morning-brief"; then
  echo "ERROR: jobs already exist on profile '$PROFILE'. Run 'hermes -p $PROFILE cron list'" >&2
  echo "and remove old ones with 'hermes -p $PROFILE cron remove <job_id>' before re-running." >&2
  exit 1
fi

# --- Job 1: 7am weekday morning brief ------------------------------------
hermes -p "$PROFILE" cron create "0 7 * * 1-5" \
  "$(cat "$PROMPTS_DIR/morning_brief.md")" \
  --name "venn-morning-brief" \
  --skill "google-workspace" \
  --deliver "telegram"

# --- Job 2: inbox sweep, 3x/day weekdays (9am, 1pm, 5pm) -----------------
hermes -p "$PROFILE" cron create "0 9,13,17 * * 1-5" \
  "$(cat "$PROMPTS_DIR/inbox_sweep.md")" \
  --name "venn-inbox-sweep" \
  --skill "google-workspace" \
  --deliver "telegram"

# --- Job 3: end-of-day follow-up nudge, weekdays 6pm ---------------------
hermes -p "$PROFILE" cron create "0 18 * * 1-5" \
  "$(cat "$PROMPTS_DIR/followup_nudge.md")" \
  --name "venn-followup-nudge" \
  --deliver "telegram"

echo
echo "3 jobs created on profile '$PROFILE'. Verify with:"
echo "  hermes -p $PROFILE cron list"
echo
echo "Reminder: schedules are wall-clock in the profile's configured"
echo "timezone (~/.hermes/profiles/$PROFILE/config.yaml -> timezone: <IANA>)."
echo "Set that from the onboarding interview BEFORE relying on these times."
