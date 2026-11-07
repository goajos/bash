#!/usr/bin/env bash
[[ -n $PS1 ]] || return

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

HISTCONTROL="ignoreboth:erasedups"
HISTSIZE=5000     # default 500
HISTFILESIZE=5000 # default 500

alias vim="nvim"
export EDITOR="nvim"
# 'v' will open the current bash line with nvim
set -o vi
bind "set show-mode-in-prompt on"
export MANPAGER="less"
export PAGER="less"

alias grep="rg"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

if [[ -f /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
elif [[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
  . "/opt/homebrew/etc/profile.d/bash_completion.sh"
  if [[ -d /opt/homebrew/etc/bash_completion.d ]]; then
    for bc in /opt/homebrew/etc/bash_completion.d/*; do
      [[ -r "$bc" ]] && . "$bc"
    done
  fi
fi

# https://github.com/andresgongora/bash-tools/blob/62db15580482853cb3cfb177420e069d1574cf3f/bash-tools/shorten_path.sh
function shorten_path() {
  local path="$PWD"
  local max_length=25
  local trunc_symbol=${3:-"…"}

  if [ -z "$path" ]; then
    echo ""
    exit
  fi

  local path=${path/#$HOME/\~}

  local dir=${path##*/}
  local dir_length=${#dir}
  local path_length=${#path}
  local print_length=$(((max_length < dir_length) ? dir_length : max_length))

  if [ $path_length -gt $print_length ]; then
    local offset=$(($path_length - $print_length))
    local truncated_path=${path:$offset}
    local clean_path="/${truncated_path#*/}"
    local removed_path=${path%%"$clean_path"}

    if [ "$removed_path" == "~" ]; then
      local short_path="~${clean_path}"
    else
      local short_path=${trunc_symbol}${clean_path}
    fi
  else
    local short_path=$path
  fi

  printf "$short_path"
}

PS1=" \u "
PS1+="\h "
PS1+="\$(shorten_path) "
PS1+="\$(__git_ps1 '(%s)') "

fastfetch
