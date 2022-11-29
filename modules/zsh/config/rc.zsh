# Enable emacs keys
bindkey -e

# Configure aliases
source "$ZSH_HOME/aliases.zsh"

# Use starship to embellish our prompt
eval $(starship init zsh)

# Use direnv for dir-local environment vars
eval $(direnv hook zsh)
