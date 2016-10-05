# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

GIT_PROMPT_FILE=$HOME/.git-prompt.sh
[[ -f $GIT_PROMPT_FILE ]] && source $GIT_PROMPT_FILE

export GIT_PS1_SHOWDIRTYSTATE=1
export PROMPT_COMMAND=__prompt_command
__prompt_command() {
    local last_error="$?"

    local ColRst='\[\e[0m\]'
    local Red='\[\e[01;31m\]'
    local BRed='\[\e[1;31m\]'
    local Gre='\[\e[01;32m\]'
    local BBlu='\[\e[01;34m\]'
    local FancyX='\342\234\227'

    PS1="${Red}[\\A] ${Gre}\\u@\\h${BBlu} \\W"
    if [[ "x$(command -v __git_ps1)" != "x" ]]; then
        PS1+='$(__git_ps1)'
    fi

    if [[ $last_error != 0 ]]; then
        PS1+=" ${BRed}$FancyX ($last_error)"
    fi

    PS1+=" ${BBlu}\$${ColRst} "
}
# Put your fun stuff here.

export HISTCONTROL=ignoredups

alias ls="ls -h --color"
alias ls.pure="`which ls`"
alias la="ls -lta"
alias ll="ls -lt"
alias grep="grep --color"
alias cal="cal -m3"
alias df="df -h"
alias wineru="LC_ALL=ru_RU.UTF-8 wine"

unset SSH_ASKPASS

export EDITOR=nvim
export BROWSER=qutebrowser
export PDFVIEWER=zathura
export PSVIEWER=$PDFVIEWER
export DVIVIEWER=$PDFVIEWER
