# Venn pilot — memory seed

Copy the filled-in version into
`~/.hermes/profiles/venn/memories/USER.md`. Entries are separated by `§`.

Everything under KNOWN is from what you already told me. Everything marked
**[ASK]** is a real gap — do not guess it, get it in the 30-minute onboarding
interview (`onboarding_interview.md`). A goal-anchored brief built on invented
goals is worse than no brief.

---

## KNOWN (safe to seed now)

```
§
The user runs Venn. Venn connects student organizations with funding, and
automates running those organizations with AI.
§
The user personally handles most meetings for Venn: scheduling them, preparing
documents for them, and the admin around them. This is the load he wants off
his plate — it is the reason this pilot exists.
§
The user already pays $100/month for Supermemory, a passive memory tool. He
values memory enough to pay for it. Roshni's job is memory that also acts.
§
Communication: draft in his voice, short and direct. Never send anything
without explicit approval in that turn.
§
```

## [ASK] — fill from the onboarding interview

```
§
GOAL: [ASK — what is he actually trying to make true in the next 6 months?
e.g. "N student orgs onboarded by <date>" or "close <$X> in funding partners"]
WHY: [ASK — what does hitting it unlock]
BLOCKERS: [ASK — what is actually in the way right now]
NEXT: [ASK — the single next physical action]
§
Funders/partners he deals with most: [ASK — 3-5 names, plus any quirks in how
each likes to be communicated with]
§
Recurring weekly meetings: [ASK — which ones, who's in them, what he needs
prepped going in]
§
Timezone: [ASK — IANA name, e.g. America/Los_Angeles. Set this in
~/.hermes/profiles/venn/config.yaml under `timezone:` or the 7am brief fires
at the wrong local time.]
§
Delivery channel: [ASK — Telegram or something else. Don't assume.]
§
```

## After seeding

```bash
cat ~/.hermes/profiles/venn/memories/USER.md   # verify
```

Then the morning brief has something to anchor to. Until the GOAL block is
real, the brief degrades to "here are your meetings" — useful, but not the
product.
