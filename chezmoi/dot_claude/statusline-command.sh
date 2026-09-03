#!/bin/sh
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')

ctx_size_m=$(awk "BEGIN { printf \"%.0fm\", $ctx_size / 1000000 }")

if [ -n "$used_pct" ] && [ -n "$input_tokens" ]; then
  used_pct_fmt=$(printf "%.0f" "$used_pct")
  used_k=$(awk "BEGIN { printf \"%.0fk\", $input_tokens / 1000 }")
  ctx_part=$(printf "%s | ⛁ %s/%s (%s%%)" "$model" "$used_k" "$ctx_size_m" "$used_pct_fmt")
elif [ -n "$used_pct" ]; then
  used_pct_fmt=$(printf "%.0f" "$used_pct")
  ctx_part=$(printf "%s | ⛁ %s (%s%%)" "$model" "$ctx_size_m" "$used_pct_fmt")
else
  ctx_part=$(printf "%s | ⛁ %s" "$model" "$ctx_size_m")
fi

five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

rate_part=""

if [ -n "$five_pct" ] && [ -n "$five_resets" ]; then
  now=$(date +%s)
  secs_left=$(( five_resets - now ))
  if [ "$secs_left" -lt 0 ]; then
    secs_left=0
  fi
  hours_left=$(( secs_left / 3600 ))
  mins_left=$(( (secs_left % 3600) / 60 ))
  five_pct_fmt=$(printf "%.0f" "$five_pct")
  rate_part=$(printf "⏱ %s%% (+%d:%02d)" "$five_pct_fmt" "$hours_left" "$mins_left")
fi

if [ -n "$week_pct" ] && [ -n "$week_resets" ]; then
  week_pct_fmt=$(printf "%.0f" "$week_pct")
  week_reset_fmt=$(date -r "$week_resets" "+%a %H:%M")
  week_part=$(printf "📅 %s%% (%s)" "$week_pct_fmt" "$week_reset_fmt")
  if [ -n "$rate_part" ]; then
    rate_part=$(printf "%s | %s" "$rate_part" "$week_part")
  else
    rate_part="$week_part"
  fi
fi

if [ -n "$rate_part" ]; then
  printf "%s | %s" "$ctx_part" "$rate_part"
else
  printf "%s" "$ctx_part"
fi
