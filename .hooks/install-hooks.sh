#!/bin/bash

HOOKS_DIR=.hooks
RESULT=0

for hook_sample in .git/hooks/*.sample
do
  hook=$(basename "$hook_sample" .sample)

  if [ -f "$HOOKS_DIR/$hook.sh" ]
  then # There is a hook to be installed

    if [ -e ".git/hooks/$hook" ]
    then # The hook already exists, check if it is correct
      if [ ! -h ".git/hooks/$hook" ] \
         || [ "$(readlink ".git/hooks/$hook")" != "../../$HOOKS_DIR/$hook.sh" ]
      then
        RESULT=1
        echo "error: $hook hook already exists"
      fi

    else # The hook doesn't exist, install a symlink
      ln -s "../../$HOOKS_DIR/$hook.sh" ".git/hooks/$hook"
    fi
  fi
done

exit $RESULT
