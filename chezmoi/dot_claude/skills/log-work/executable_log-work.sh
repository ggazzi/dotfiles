#!/usr/bin/env bash
# Appends a Work log entry for this Claude Code session to the Claude log section of a Daily note.
# Usage: log-work.sh <session-id> <vault-dir, empty for none> <sentence>
set -euo pipefail
sid=$1 vault=$2 sentence=$3

transcript=$(find "$HOME/.claude/projects" -name "$sid.jsonl" -print -quit)
[ -n "$transcript" ] || { echo "log-work: no transcript for session $sid" >&2; exit 1; }

# Span: from the first prompt after the previous log-work call (or session start) to the
# last message. Gaps over 15 min are pauses. Output: "start end day", then one "from to" per pause,
# as local HH:MM (jq's strflocaltime, since `date -d @N` is GNU-only).
mapfile -t times < <(jq -rs '
    def inv: (.type == "user" and (.message.content | type) == "string"
              and (.message.content | contains("<command-name>/log-work</command-name>")))
          or (.type == "assistant" and any(.message.content[]?; .type == "tool_use" and .name == "Skill" and .input.skill == "log-work"));
    def prompt: .type == "user" and (.isMeta | not)
          and ((.message.content | type) == "string" or any(.message.content[]?; .type == "text"))
          and (.message.content | tostring | contains("<command-name>/clear<") | not);
    def hm: strflocaltime("%H:%M");
    map(select((.type == "user" or .type == "assistant") and .timestamp)) | sort_by(.timestamp)
    | (map(inv) | indices(true)) as $inv
    | .[(if ($inv | length) >= 2 then $inv[-2] + 1 else 0 end):]
    | .[(map(prompt) | index(true)) // 0:]
    | map(.timestamp | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601) as $t
    | "\($t[0] | hm) \($t[-1] | hm) \($t[-1] | strflocaltime("%F"))",
      (range(1; $t | length) | select($t[.] - $t[. - 1] > 900) | "\($t[. - 1] | hm)–\($t[.] | hm)")
' "$transcript")

read -r start end day <<<"${times[0]}"
pause=""
[ ${#times[@]} -eq 1 ] || pause=" (pause $(printf '%s, ' "${times[@]:1}" | sed 's/, $//'))"

project=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")
span="$start–$end"
suffix="$pause · $project · $sentence"

if [ -z "$vault" ] || [ ! -d "$vault" ]; then
    printf 'Vault not reachable. Paste into Daily/%s.md (add the heading if missing):\n\n## Claude log\n- %s %s%s\n' \
        "$day" "$span" "$(date +%Z)" "$suffix"
    exit 0
fi

entry="- $span$suffix"
note="$vault/Daily/$day.md"
mkdir -p "$vault/Daily"
[ -e "$note" ] || cp "$vault/Templates/Daily Note.md" "$note"
if grep -qx '## Claude log' "$note"; then
    # Insert after the section's last non-blank line, before the next heading or EOF.
    awk -v entry="$entry" '
        sec && /^#+ / { print entry; printf "%s", blanks; blanks = ""; sec = 0 }
        sec && /^[[:space:]]*$/ { blanks = blanks $0 "\n"; next }
        { printf "%s", blanks; blanks = ""; print }
        $0 == "## Claude log" { sec = 1 }
        END { if (sec) { print entry; printf "%s", blanks } }
    ' "$note" >"$note.tmp" && mv "$note.tmp" "$note"
else
    [ -z "$(tail -c1 "$note")" ] || echo >>"$note"
    printf '\n## Claude log\n%s\n' "$entry" >>"$note"
fi
echo "Logged to $note: $entry"
