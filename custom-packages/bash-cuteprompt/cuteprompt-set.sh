#!/bin/bash
# Colorize prompt when colors are available

has_colors()
{
  local num_colors
  # shellcheck disable=SC2016
  num_colors=$(infocmp \
    | grep     'colors#\(0x[0-9a-f]\+\|[0-9]\+\)' \
    | sed 's_^.*colors#\(0x[0-9a-f]\+\|[0-9]\+\).*$_\1_' \
    )

  # convert if its in hex
  num_colors=$((num_colors))

  [[ "$num_colors" -ge 8 ]] && return 0 || return 1
}

colorized_prompt()
{
  local open_bracket
  local close_bracket
  open_bracket="\[\e[01;30m\]["
  close_bracket="\[\e[01;30m\]]"

  local user_and_host
  user_and_host="$(if [[ $EUID == 0 ]]; then echo '\[\e[01;31m\]\h'; else echo '\[\e[00;32m\]\u\[\e[01;32m\]@\[\e[00;32m\]\h'; fi)"

  local current_dir
  current_dir="\[\e[01;34m\]\W"

  local last_command_status
  last_command_status="\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)"

  local reset_color
  reset_color="\[\e[00m\]"

  echo "$open_bracket $last_command_status $user_and_host $current_dir $close_bracket $reset_color"
}


if has_colors
then

  # load colors for ls
  if type -P dircolors >/dev/null
  then
    for colorsfile in "$HOME/.dircolors" "/etc/DIRCOLORS"
    do [[ -f ${colorsfile} ]] && eval "$(dircolors -b "${colorsfile}")"
    done
  fi

  PS1="$(colorized_prompt)"


  # Use colors by default
  alias ls="ls --color=auto"
  alias dir="dir --color=auto"
  alias grep="grep --color=auto"
  alias egrep="egrep --color=auto"
fi
