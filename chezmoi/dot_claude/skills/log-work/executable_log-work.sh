#!/usr/bin/env bash
# Appends a Work log entry for this Claude Code session to the Claude log section of a Daily note.
# Usage: log-work.sh <session-id> <vault-dir, empty for none> <sentence>
#        log-work.sh --digest <session-id> <vault-dir>
# --digest prints what a new entry would cover instead: "<prompt count> <seconds>", then the
# messages as plain text, for log-work-auto.sh to summarize.
set -euo pipefail
mode=log
[ "$1" != --digest ] || { mode=digest; shift; }
sid=$1 vault=$2 sentence=${3:-}

transcript=$(find "$HOME/.claude/projects" -name "$sid.jsonl" -print -quit)
[ -n "$transcript" ] || { echo "log-work: no transcript for session $sid" >&2; exit 1; }

# The session's previous log line, if any: its Daily's date and last window end ("YYYY-MM-DD HH:MM").
# Lines are sorted within a Daily and a session's lines never overlap, so the last match is the latest.
since=""
if [ -n "$vault" ] && [ -d "$vault/Daily" ]; then
    prev=$(grep -l " · ${sid:0:8}\$" "$vault"/Daily/*.md 2>/dev/null | tail -1) || true
    if [ -n "$prev" ]; then
        windows=$(grep " · ${sid:0:8}\$" "$prev" | tail -1)
        windows=${windows%% · *}
        since="$(basename "$prev" .md) ${windows##*–}"
    fi
fi

# The entry covers the first prompt after the previous log line (or session start) to the last
# message. Active windows split it at gaps over 15 min and at midnight. Output: the day of the
# last message, then one "from–to" per window, as local HH:MM (jq's strflocaltime, since
# `date -d @N` is GNU-only).
mapfile -t times < <(jq -rs --arg since "$since" --arg mode "$mode" '
    def text: if (.message.content | type) == "string" then .message.content
              else ([.message.content[]? | select(.type == "text") | .text] | join(" ")) end;
    def prompt: .type == "user" and (.isMeta | not) and (text | length > 0)
          and (text | contains("<command-name>/clear<") | not);
    def hm: strflocaltime("%H:%M");
    map(select((.type == "user" or .type == "assistant") and .timestamp)
        | .t = (.timestamp | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601)
        | select(.t | strflocaltime("%F %H:%M") > $since))
    | sort_by(.t)
    | .[(map(prompt) | index(true)) // length:]
    | if $mode == "digest" then
        "\(map(select(prompt)) | length) \(if length > 0 then .[-1].t - .[0].t else 0 end)",
        (.[] | select(prompt or .type == "assistant") | select(text | length > 0)
         | "\(if .type == "user" then "USER" else "ASSISTANT" end): \(text | .[0:400])")
      else
        map(.t) as $t | select($t | length > 0)
        | ([0] + [range(1; $t | length) | select($t[.] - $t[. - 1] > 900)] + [$t | length]) as $cut
        | ($t[-1] | strflocaltime("%F")),
          (range(1; $cut | length) | [$t[$cut[. - 1]], $t[$cut[.] - 1]]
           | if (.[0] | strflocaltime("%F")) == (.[1] | strflocaltime("%F"))
             then "\(.[0] | hm)–\(.[1] | hm)"
             else "\(.[0] | hm)–24:00", "00:00–\(.[1] | hm)" end)
      end
' "$transcript")
[ $mode = log ] || { printf '%s\n' "${times[@]}"; exit 0; }

[ ${#times[@]} -gt 0 ] || { echo "log-work: nothing to log since the previous line"; exit 0; }
day=${times[0]}
windows=$(printf '%s, ' "${times[@]:1}" | sed 's/, $//')

# Repository: owner/name from the origin remote; else the directory, with ~ for home.
if url=$(git remote get-url origin 2>/dev/null); then
    repo=$(sed -E 's#\.git$##; s#.*[:/]([^/:]+/[^/:]+)$#\1#' <<<"$url")
else
    repo=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
    case $repo in "$HOME" | "$HOME"/*) repo="~${repo#"$HOME"}" ;; esac
fi
suffix=" · $repo · $sentence · ${sid:0:8}"

if [ -z "$vault" ] || [ ! -d "$vault" ]; then
    printf 'Vault not reachable. Paste into Daily/%s.md (add the heading if missing):\n\n## Claude log\n- %s %s%s\n' \
        "$day" "$windows" "$(date +%Z)" "$suffix"
    exit 0
fi

entry="- $windows$suffix"
note="$vault/Daily/$day.md"
mkdir -p "$vault/Daily"
[ -e "$note" ] || cp "$vault/Templates/Daily Note.md" "$note"
if grep -qx '## Claude log' "$note"; then
    # Insert before the first entry that starts later, else after the section's last non-blank
    # line, before the next heading or EOF.
    awk -v entry="$entry" '
        sec && /^- [0-9][0-9]:[0-9][0-9]/ && substr($0, 3, 5) > substr(entry, 3, 5) {
            printf "%s", blanks; blanks = ""; print entry; sec = 0
        }
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
