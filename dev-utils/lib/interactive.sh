# Ask a user a binary question.
#
# Arguments:
#  - $1: Question to be asked.
#  - $2: (optional) Default choice, must be "Y" or "N".
#
# Exit codes:
#  - 0: user answered with yes
#  - 1: user answered with no 
ask_yes_or_no() {
  local default=$2
  local prompt=$1

  case $default in
    [Yy]* ) prompt="$prompt [Y/n]";;
    [Nn]* ) prompt="$prompt [y/N]";;
    * ) prompt="$prompt [y/n]";;
  esac

  local choice
  while true; do
    read -rp "$prompt " choice
    case $choice in
      [Yy]* ) return 0;;
      [Nn]* ) return 1;;
      "" ) 
        case $default in
          [Yy]* ) return 0;;
          [Nn]* ) return 1;;
          * ) echo "Please answer yes or no.";;
        esac
      ;;
      * ) echo "Please answer yes or no.";;
    esac
  done
}