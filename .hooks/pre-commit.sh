#!/bin/bash

ERROR=0

# Ensure uncommited changes aren't visible
STASH_NAME="pre-commit-$(date +%s)"
git stash save -q --keep-index "$STASH_NAME"

# Run shellcheck
shopt -qs globstar
if ! (shellcheck ./**/*.sh .hooks/*.sh && shellcheck -x dotfiles/bash/.bashrc)
then
  ERROR=1
  echo "There are issues in some bash scripts."
  echo "Please fix them before committing."
fi

# Restore uncommited changes
STASH_INDEX=$(git stash list | grep "$STASH_NAME" | sed 's_[^{]*{\([^}]*\)}:.*_\1_')
if [ -n "$STASH_INDEX" ]
then
  git stash pop -q --index "$STASH_INDEX"
fi

exit $ERROR
