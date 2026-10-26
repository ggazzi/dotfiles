#!/usr/bin/env bash
# Runnable check for the log-work skill script: active windows, per-session deltas,
# repository label and Daily note placement.
set -euo pipefail
script="$(cd "$(dirname "$0")" && pwd)/chezmoi/dot_claude/skills/log-work/executable_log-work.sh"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
export HOME="$tmp/home" TZ=UTC
mkdir -p "$HOME/.claude/projects/x" "$HOME/plain" "$tmp/repo" "$tmp/vault/Templates" "$tmp/vault/Daily"
git -C "$tmp/repo" init -q && git -C "$tmp/repo" remote add origin git@github.com:owner/name.git
printf -- '---\ntype: daily\n---\n## Time Tracking\n```simple-time-tracker\n```\n\n## Claude log\n' >"$tmp/vault/Templates/Daily Note.md"

day=2026-10-23
u() { printf '{"type":"user","timestamp":"%sT%s.000Z","message":{"content":"%s"}}\n' "$day" "$1" "$2"; }
a() { printf '{"type":"assistant","timestamp":"%sT%s.000Z","message":{"content":[{"type":"text","text":"ok"}]}}\n' "$day" "$1"; }
transcript="$HOME/.claude/projects/x/sess1234-abcd.jsonl"
{
    u 07:59:00 "<command-name>/clear</command-name>"; u 08:00:00 "do A"; a 08:05:00
    u 09:25:00 "do B"; a 09:38:00; a 09:50:00; a 10:02:00
    u 10:20:00 "more B" # 18 min gap -> new window
    a 10:33:00; a 10:46:00
} >"$transcript"

run() { (cd "${dir:-$tmp/repo}" && bash "$script" sess1234-abcd "$1" "$2"); }
note="$tmp/vault/Daily/$day.md"
fail() { echo "FAIL: $1"; cat "$2"; exit 1; }

# missing note: created from template, entry under the template's section
run "$tmp/vault" "Did A and B." >/dev/null
e1='- 08:00–08:05, 09:25–10:02, 10:20–10:46 · owner/name · Did A and B. · sess1234'
[ "$(tail -2 "$note")" = "## Claude log
$e1" ] || fail "missing note" "$note"

# resumed session: logs only what came after its previous line, even once the vault's
# review has inserted an effort link into that line
sed -i.bak 's/10:46 · owner/10:46 · [[Textum]] · owner/' "$note"
{ u 10:46:40 "/log-work"; u 11:30:00 "do C"; a 11:40:00; a 11:50:00; } >>"$transcript"
[ "$(bash "$script" --digest sess1234-abcd "$tmp/vault")" = "1 1200
USER: do C
ASSISTANT: ok
ASSISTANT: ok" ] || { echo "FAIL: digest"; bash "$script" --digest sess1234-abcd "$tmp/vault"; exit 1; }
run "$tmp/vault" "Did C." >/dev/null
e1='- 08:00–08:05, 09:25–10:02, 10:20–10:46 · [[Textum]] · owner/name · Did A and B. · sess1234'
e2='- 11:30–11:50 · owner/name · Did C. · sess1234'
[ "$(tail -3 "$note")" = "## Claude log
$e1
$e2" ] || fail "delta" "$note"

# another session: inserted by first window start, and the section ends before the next heading
printf '\n## Later\ntext\n' >>"$note"
{ u 09:00:00 "do D"; a 09:10:00; } >"$HOME/.claude/projects/x/other999.jsonl"
(cd "$tmp/repo" && bash "$script" other999 "$tmp/vault" "Did D.") >/dev/null
[ "$(sed -n '/^## Claude log/,$p' "$note")" = "## Claude log
$e1
- 09:00–09:10 · owner/name · Did D. · other999
$e2

## Later
text" ] || fail "ordering" "$note"

# window across midnight: split, in the Daily of the last message
{ u 23:40:00 "do E"; a 23:55:00; day=2026-10-24 a 00:05:00; day=2026-10-24 a 00:20:00; } \
    >"$HOME/.claude/projects/x/night000.jsonl"
(cd "$tmp/repo" && bash "$script" night000 "$tmp/vault" "Did E.") >/dev/null
note="$tmp/vault/Daily/2026-10-24.md"
[ "$(tail -1 "$note")" = "- 23:40–24:00, 00:00–00:20 · owner/name · Did E. · night000" ] || fail "midnight" "$note"

# nothing since the previous line: no entry
before=$(cat "$note")
(cd "$tmp/repo" && bash "$script" night000 "$tmp/vault" "Nothing.") >/dev/null
[ "$(cat "$note")" = "$before" ] || fail "nothing new" "$note"

# no remote, no vault: directory with ~, paste block with the timezone
out=$(dir="$HOME/plain" run "" "Did A and B.")
grep -qF 'Daily/2026-10-23.md' <<<"$out" &&
    grep -qF -- '- 08:00–08:05, 09:25–10:02, 10:20–10:46, 11:30–11:50 UTC · ~/plain · Did A and B. · sess1234' <<<"$out" ||
    { echo "FAIL: no vault"; echo "$out"; exit 1; }

echo PASS
