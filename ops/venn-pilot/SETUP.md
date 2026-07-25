# Venn Concierge Pilot — Setup Checklist

Design doc: `~/.gstack/projects/roshni/aayu-main-design-20260724-094500.md`
Status: infrastructure built and tested below. Remaining steps require you
(the OAuth grant is the Venn founder's own Google login — not something an
agent can or should do on his behalf).

## Already done (verified working in this session)

- [x] hermes installed (`uv sync` in `~/Workspace/developer/hermes`)
- [x] Isolated `venn` profile created at `~/.hermes/profiles/venn` — fully
      separate from your personal hermes memory/sessions/skills. 89 bundled
      skills synced, including `google-workspace`.
- [x] Three cron jobs created on the `venn` profile (verified via
      `hermes -p venn cron list`):
  - `venn-morning-brief` — `0 7 * * 1-5`, delivers via telegram
  - `venn-inbox-sweep` — `0 9,13,17 * * 1-5`, delivers via telegram
  - `venn-followup-nudge` — `0 18 * * 1-5`, delivers via telegram
- [x] Prompts written per the approved design doc's rules — suppress-empty
      (`[SILENT]` marker), weekday-only, explicit-only commitment tracking
      for week 1, send-gated (drafts only, never auto-send):
  `ops/venn-pilot/prompts/{morning_brief,inbox_sweep,followup_nudge}.md`
- [x] Onboarding interview script: `ops/venn-pilot/onboarding_interview.md`
- [x] `create_jobs.sh` is idempotent-safe — refuses to double-create jobs.

## Remaining steps — in order

### 1. Run the onboarding interview (you + the Venn founder, ~30 min)

Follow `ops/venn-pilot/onboarding_interview.md` live. This seeds memory
(`~/.hermes/profiles/venn/memories/USER.md` and `MEMORY.md`) with real org
context so the first brief isn't generic — and gets his explicit verbal OK
on data handling before any OAuth screen appears. Do this BEFORE step 2.

```bash
cd ~/Workspace/developer/hermes && source .venv/bin/activate
hermes -p venn chat
```

### 2. Google OAuth (the founder does this himself, in his own browser)

This is his Gmail/Calendar — the consent screen must be him, not you. Walk
him through `skills/productivity/google-workspace/SKILL.md` "First-Time
Setup" section live, in the same chat session from step 1 (the agent can
narrate the steps and run the check/exchange commands, but the browser
consent click is his). Short version:

```bash
export HERMES_HOME=~/.hermes/profiles/venn   # REQUIRED — without this the
                                              # script writes to your personal
                                              # ~/.hermes instead of the venn
                                              # profile. Keep it set for every
                                              # command in this section.
GSETUP="python ~/.hermes/profiles/venn/skills/productivity/google-workspace/scripts/setup.py"
$GSETUP --check                                    # confirm not already set up
$GSETUP --client-secret /path/he/gives/you.json     # after he creates a GCP OAuth client
$GSETUP --auth-url --services email,calendar --format json   # send him the URL
$GSETUP --auth-code "THE_CODE_HE_PASTES_BACK"
$GSETUP --check                                     # should print AUTHENTICATED
```

Scopes requested by default include `gmail.readonly`, `gmail.send`,
`gmail.modify`, and `calendar` (full) — matches the design doc's requirement
that send be available (application-layer approval-gated, not scope-gated).

Known constraint: an unverified GCP app in "Testing" status expires refresh
tokens after 7 days. That lands mid-pilot (day 7 of 14). Plan to re-run the
`--auth-url` / `--auth-code` exchange once around day 7, or have him add his
account under an internal Workspace app type if his domain supports it — flag
this to him now so it isn't a surprise.

### 3. Telegram delivery

```bash
hermes -p venn gateway setup
```

Follow the prompts for Telegram — needs a bot token from @BotFather (he
creates the bot, or you create one dedicated to this pilot and add him as
the chat). Confirm with him in the onboarding interview (step 1, question 7)
that Telegram is actually where he wants this — don't assume.

### 4. Set the profile's timezone

From onboarding interview question 6. Edit:

```bash
$EDITOR ~/.hermes/profiles/venn/config.yaml
# add/set: timezone: America/Los_Angeles   (his IANA zone, not yours)
```

The cron schedules (`0 7 * * 1-5` etc.) are wall-clock in this timezone —
without it set, jobs fire on the server's local time, which may not be his.

### 5. Start the gateway so jobs actually fire

```bash
hermes -p venn gateway install     # installs as background service (systemd/launchd)
hermes -p venn gateway status      # confirm running
```

Without this running, `cron list` will keep warning "Gateway is not running
— jobs won't fire automatically" — the jobs exist but are inert until the
gateway is up.

### 6. Watch day 1-5 closely

Per the design doc's gates: does he respond to messages, does he open
Telegram unprompted by day 5. Check job output/delivery logs if something
seems off:

```bash
hermes -p venn cron list          # next_run_at, active status
ls ~/.hermes/profiles/venn/cron/output/   # per-run output, if jobs ran with issues
```

If day 5 looks good, proceed to day 14 per the design doc's success
criteria. If not, that's the answer the pilot was built to get — cheaply.
