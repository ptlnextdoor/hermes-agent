# Venn Pilot — 30-Minute Onboarding Interview

Run this once, live, with the pilot user (the Venn founder), before the cron
jobs go active. Purpose: seed memory with enough real context that the day-1
brief is already specific instead of generic. This is Open Question 4 from
the approved design doc, answered.

Run it as a normal chat session on the `venn` profile:

```bash
venn chat
```

(or `hermes -p venn chat` if the `venn` wrapper alias isn't on PATH yet)

Ask these in order. After each answer, explicitly ask the agent to save it to
memory before moving on — don't rely on passive capture for the first seed.

1. **The org.** "What is Venn, in your own words — what does it actually do
   day to day?" (org name, model: connects student orgs with funders,
   AI-automates org ops)
2. **The funders.** "Who are the 3-5 funders or funding sources you deal with
   most? Any quirks about how each one likes to be communicated with?"
3. **The meeting cadence.** "What recurring meetings do you have every week?
   Who's in them, and what do you usually need prepped going in?"
4. **The admin pain, specifically.** "Walk me through last Tuesday — what
   admin tasks ate your time?" (this is the status-quo evidence from the
   design doc — get it in his own words, store verbatim quotes where useful)
5. **Communication style.** "When I draft a reply on your behalf, what tone
   should it have? Formal, casual, short, long?"
6. **Timezone.** "What timezone are you in?" — set this in
   `~/.hermes/profiles/venn/config.yaml` under `timezone:` (IANA name, e.g.
   `America/Los_Angeles`) before the 7am brief job is scheduled, or the brief
   will fire at the wrong wall-clock time.
7. **Delivery channel confirmation.** "You'll get this over Telegram — is
   that where you actually want it, or somewhere else?" (Open Question 2 —
   ask, don't assume.)
8. **Data handling — say this explicitly, don't skip it:** "This pilot reads
   your Gmail and Calendar and will draft replies for your approval. Your
   data stays on [founder]'s machine for the two-week pilot. If we stop at
   any point, I'll delete all of it — memory, tokens, everything. Sound
   good?" Get a clear yes before running Google OAuth.

Ask the agent explicitly to save each answer via its memory tool as you go
("save that to memory") — org/funder facts and communication style belong in
`USER.md` (what the agent knows about the user); operational facts (meeting
cadence, recurring context) can go in either. After the interview, confirm
what got stored:

```bash
cat ~/.hermes/profiles/venn/memories/USER.md
cat ~/.hermes/profiles/venn/memories/MEMORY.md
```

If anything important didn't get captured, append it directly to the
relevant file (entries are separated by `§`) or ask the agent to add it in a
follow-up chat turn.

External memory providers (Honcho, mem0, etc.) are available via
`venn memory setup` if the built-in MEMORY.md/USER.md files prove
insufficient — skip this for the pilot; built-in memory is enabled by
default and is enough to test the loop.
