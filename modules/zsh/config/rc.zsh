# Enable emacs keys
bindkey -e

# Configure aliases
source "$ZSH_HOME/aliases.zsh"

# Configure completion
source "$ZSH_HOME/completion.zsh"

# Use starship to embellish our prompt
(which starship >/dev/null) && eval "$(starship init zsh)"

# Use direnv for dir-local environment vars
(which direnv >/dev/null) && eval "$(direnv hook zsh)"
