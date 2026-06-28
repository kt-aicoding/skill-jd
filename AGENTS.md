# Repository Guidelines

- GitHub: `kt-aicoding/skill-jd`
- Category: standalone browser-automation skill repository.
- Installed skill name: `jd-shopping`; repository name is `skill-jd`.

## Editing Rules

- Keep reusable skill instructions in `SKILL.md`.
- Keep helper scripts under `scripts/` and agent metadata under `agents/`.
- Preserve the safety boundary: the skill may assist low-frequency, visible, user-supervised shopping flows, but must not checkout, pay, bypass verification, scrape at scale, or hide automation.
- Never commit browser profiles, cookies, tokens, screenshots, snapshots, account details, addresses, phone numbers, orders, payment data, or copied `.env` values.
- Do not weaken the destructive-command guardrails in `scripts/pw-jd.sh` without explicit user approval.

## Validation

After edits, run the narrow structural checks:

```bash
test -f SKILL.md
test -f agents/openai.yaml
test -f scripts/pw-jd.sh
```

If available, run the local skill validator against this repository or the installed skill directory.
