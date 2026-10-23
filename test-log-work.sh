#!/usr/bin/env bash
# Runnable check for the log-work skill script: span/pause math and Daily note placement.
set -euo pipefail
script="$(cd "$(dirname "$0")" && pwd)/chezmoi/dot_claude/skills/log-work/executable_log-work.sh"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
export HOME="$tmp/home" TZ=UTC
mkdir -p "$HOME/.claude/projects/x" "$tmp/myproj" "$tmp/vault/Templates" "$tmp/vault/Daily"
printf -- '---\ntype: daily\n---\n## Time Tracking\n```simple-time-tracker\n```\n\n## Claude log\n' >"$tmp/vault/Templates/Daily Note.md"

u() { printf '{"type":"user","timestamp":"2026-10-23T%s.000Z","message":{"content":"%s"}}\n' "$1" "$2"; }
a() { printf '{"type":"assistant","timestamp":"2026-10-23T%s.000Z","message":{"content":[{"type":"text","text":"ok"}]}}\n' "$1"; }
inv='<command-name>/log-work</command-name>'
{
    u 07:59:00 "<command-name>/clear</command-name>"; u 08:00:00 "do A"; a 08:05:00
    u 08:10:00 "$inv"; a 08:10:30 # previous log-work: span starts after it
    u 09:25:00 "do B"; a 09:38:00; a 09:50:00; a 10:02:00
    u 10:20:00 "more B" # 18 min gap -> pause
    a 10:33:00; a 10:46:00
    u 10:48:00 "$inv"; a 10:48:10
} >"$HOME/.claude/projects/x/sess.jsonl"

run() { (cd "$tmp/myproj" && bash "$script" sess "$1" "Did B."); }
entry='- 09:25–10:48 (pause 10:02–10:20) · myproj · Did B.'
fail() { echo "FAIL: $1"; cat "$2"; exit 1; }

# missing note: created from template, entry under the template's section
run "$tmp/vault" >/dev/null
note="$tmp/vault/Daily/2026-10-23.md"
[ "$(tail -2 "$note")" = "## Claude log
$entry" ] || fail "missing note" "$note"

# existing section followed by another heading: entry goes after the last one
printf '## Claude log\n- old\n\n## Later\ntext\n' >"$note"
run "$tmp/vault" >/dev/null
[ "$(cat "$note")" = "## Claude log
- old
$entry

## Later
text" ] || fail "section with following heading" "$note"

# note without section (older notes): heading appended
printf 'notes' >"$note"
run "$tmp/vault" >/dev/null
[ "$(cat "$note")" = "notes

## Claude log
$entry" ] || fail "missing section" "$note"

# no vault: prints a paste block with the timezone
out=$(run "")
grep -qF 'Daily/2026-10-23.md' <<<"$out" && grep -qF -- '- 09:25–10:48 UTC (pause 10:02–10:20) · myproj · Did B.' <<<"$out" ||
    { echo "FAIL: no vault"; echo "$out"; exit 1; }

echo PASS
