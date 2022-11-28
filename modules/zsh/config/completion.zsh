# Ensure the completion engine is loaded and initialised
autoload -U compinit
compinit -i

unsetopt menu_complete  # do not autoselect the first completion entry
setopt auto_menu        # show completion menu on successive tab press

setopt complete_in_word # in-word completion allowed
setopt always_to_end

zmodload -i zsh/complist
