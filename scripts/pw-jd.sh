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

export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
export PLAYWRIGHT_CLI_SESSION="${PLAYWRIGHT_CLI_SESSION:-jd}"

PWCLI="${PWCLI:-$CODEX_HOME/skills/playwright/scripts/playwright_cli.sh}"
if [[ ! -x "$PWCLI" ]]; then
  echo "Error: Playwright CLI wrapper not found or not executable: $PWCLI" >&2
  exit 1
fi

exec "$PWCLI" "$@"
