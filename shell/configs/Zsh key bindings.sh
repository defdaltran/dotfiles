#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Description
#   Key bindings for the Zsh shell.
# ------------------------------------------------------------------------------

if [[ $SHELL_TYPE == 'zsh' ]]; then

  # Use Emacs line editing mode
  bindkey -e

  # <CTRL><LEFT> => previous word
  bindkey '^[[1;5D' emacs-backward-word

  # <CTRL><RIGHT> => next word
  bindkey '^[[1;5C' emacs-forward-word

  # Custom ZLE Widget to bind F5 => 'source ~/.zshrc'
  _refresh()
  {
	  source ~/.zshrc
  }
  zle -N _refresh
  bindkey '^[[15~' _refresh

fi
