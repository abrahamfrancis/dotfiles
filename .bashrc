#!/bin/bash
#
# ~/.bashrc
# Load using .bash_profile
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set TERM
TERM='xterm-256color'

alias ls='ls --color=auto'

alias up='cd ..'

# Cycle through all candidates
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

# Store Return Value
PROMPT_COMMAND='RETURN_VALUE=$?;'

# Version Control Parse
__rc_prompt_git() {
	eval "$(git rev-parse --is-inside-git-dir 2>/dev/null)" &&
		return 1
	eval "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ||
		return 1
	git status &>/dev/null
	branch=$(git symbolic-ref --quiet HEAD 2>/dev/null) ||
		branch=$(git rev-parse --short HEAD 2>/dev/null) ||
		branch='unknown'
	branch=${branch##*/}
	git diff --quiet --ignore-submodules --cached ||
		state=${state}+
	git diff-files --quiet --ignore-submodules -- ||
		state=${state}!f
	eval git rev-parse --verify refs/stash &>/dev/null &&
		state=${state}^
	[ -n "$(git ls-files --others --exclude-standard)" ] &&
		state="${state}?"
	printf ' [git: %s]' "${branch:-unknown}${state}"
}

__rc_prompt_hg() {
	hg branch &>/dev/null || return 1
	BRANCH="$(hg branch 2>/dev/null)"
	[[ -n "$(hg status 2>/dev/null)" ]] && STATUS="!"
	printf ' [hg: %s]' "${BRANCH:-unknown}${STATUS}"
}

__rc_prompt_svn() {
	svn info &>/dev/null || return 1
	URL="$(svn info 2>/dev/null |
		awk -F': ' '$1 == "URL" {print $2}')"
	ROOT="$(svn info 2>/dev/null |
		awk -F': ' '$1 == "Repository Root" {print $2}')"
	BRANCH=${URL/$ROOT/}
	BRANCH=${BRANCH#/}
	BRANCH=${BRANCH#branches/}
	BRANCH=${BRANCH%%/*}
	[[ -n "$(svn status 2>/dev/null)" ]] && STATUS="!"
	printf ' [svn: %s]' "${BRANCH:-unknown}${STATUS}"
}

VERSION_CONTROLLER='git'

__rc_prompt_vcs() {
	if [ $VERSION_CONTROLLER == 'git' ]; then
		__rc_prompt_git
	elif [ $VERSION_CONTROLLER == 'hg' ]; then
		__rc_prompt_hg
	elif [ $VERSION_CONTROLLER == 'svn' ]; then
		__rc_prompt_svn
	fi
}

__rc_status() {
	if [ "$RETURN_VALUE" != 0 ]; then
		cols=$(tput cols)
		cols=$((cols - 3))
		tput setaf 1
    printf "\033[%dG'_'" "$cols"
	fi
}

__rc_venv() {
	if [ -z "$VIRTUAL_ENV" ]; then
		printf '╭'
	else
		VENV_NAME=$(basename "$VIRTUAL_ENV")
		printf '╭─<%s>\n├' "$VENV_NAME"
	fi
}

# toolbox indicator
__rc_toolbox() {
	if [[ -f /run/.containerenv && -f /run/.toolboxenv ]]; then
		printf "⬢"
	fi
}

# Disable Default Virtual Env Prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# PS Strings
PS1='\[$(tput bold)\]\[$(tput dim)\]\[$(tput setaf 6)\]$(__rc_venv)\w $(__rc_toolbox)\[$(tput setaf 2)\]$(__rc_prompt_vcs)$(__rc_status)\n\[$(tput setaf 6)\]├\$ \[$(tput sgr0)\]'
PS2='\[$(tput dim)\]\[$(tput setaf 6)\]├\[$(tput bold)\]> \[$(tput sgr0)\]'

# Disable Duplicates in ~/.bash_history
export HISTCONTROL=ignoreboth:erasedups

export PATH="$HOME/go/bin/:$PATH"
export PATH="$HOME/.local/bin/:$PATH"
