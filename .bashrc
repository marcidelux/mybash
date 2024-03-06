# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

deduplicate_history() {
    local history_file="$1"
    if [[ -f "$history_file" ]]; then
        awk '!seen[$0]++' "$history_file" > "${history_file}.tmp" && mv "${history_file}.tmp" "$history_file"
    fi
}

# Function to select or create a Bash history file
select_or_create_bash_history() {
    if [ ! -d "$HOME/.bash_histories" ]; then
        mkdir -p "$HOME/.bash_histories"
        echo "Created the ~/.bash_histories directory for storing Bash history files."
    fi
    echo "Select a Bash history file or create a new one:"
    # Explicitly add "Create new history file" as the first option
    options=("Create new history file")
    # Append existing history files to the options list, ignoring . and ..
    for file in $(ls -A ~/.bash_histories/ | grep -v -e '^\.$' -e '^\..$'); do
        options+=("$file")
    done

    select opt in "${options[@]}"; do
        case $REPLY in
            # If the option for creating a new history file is selected
            1)
                echo "Enter name for new history file (without spaces):"
                read -r newname
                newhistfile=~/.bash_histories/.bh_${newname}
                touch "$newhistfile"
                export HISTFILE="$newhistfile"
                export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
                echo "Created and using new history file: $HISTFILE"
                break
                ;;
            # If an existing history file is selected
            *)
                if [ -n "$opt" ] && [ "$opt" != "Create new history file" ]; then
                    echo "Deduplicate history file before load"
                    deduplicate_history ~/.bash_histories/"$opt"
                    export HISTFILE=~/.bash_histories/"$opt"
                    export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
                    echo "Using history file: $HISTFILE"
                    break
                else
                    echo "Invalid selection. Please try again."
                fi
                ;;
        esac
    done
}
#Setup history
select_or_create_bash_history
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Function definitions
# Similarly to aliases it loads functions from seperate file called: .bash_functions
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Adding paths
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"