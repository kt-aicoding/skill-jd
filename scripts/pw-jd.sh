#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  close|close-all|kill-all|delete-data|cookie-clear|localstorage-clear|sessionstorage-clear)
    if [[ "${JD_ALLOW_DESTRUCTIVE:-}" != "1" ]]; then
      echo "Refusing destructive JD browser command: $1" >&2
      echo "Set JD_ALLOW_DESTRUCTIVE=1 only after the user explicitly asks." >&2
      exit 2
    fi
    ;;
esac

if ! command -v npx >/dev/null 2>&1; then
  echo "Error: npx is required but not found on PATH." >&2
  exit 1
fi

export PLAYWRIGHT_CLI_SESSION="${PLAYWRIGHT_CLI_SESSION:-jd}"

if [[ -z "${PWCLI:-}" ]]; then
  for candidate in \
    "${CODEX_SKILLS_HOME:-$HOME/.agents/skills}/playwright/scripts/playwright_cli.sh" \
    "${CODEX_HOME:-$HOME/.codex}/skills/playwright/scripts/playwright_cli.sh"; do
    if [[ -x "$candidate" ]]; then
      PWCLI="$candidate"
      break
    fi
  done
fi

if [[ -z "${PWCLI:-}" || ! -x "$PWCLI" ]]; then
  echo "Error: Playwright CLI wrapper not found. Set PWCLI or install the Playwright skill." >&2
  echo "Checked user Skills under ~/.agents/skills and the legacy \$CODEX_HOME/skills path." >&2
  exit 1
fi

exec "$PWCLI" "$@"
