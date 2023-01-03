#################################################################
#                                                               #
#  Configure some sensible defaults, most taken from Geerling   #
#                                                               #
#################################################################

# Colors.
unset LSCOLORS
export CLICOLOR=1

# caused issues with testcafe finding browsers because grep was used and it had color characters f*cking up the paths testcafe used
# may be useful when wanting to pipe colourised output (normally does not retain color characters)
# export CLICOLOR_FORCE=1

if  command -v pathadd > /dev/null 2>&1; then
  echo "WARNING: pathadd is already in context, possibly this file has been sourced twice, or another service has added pathadd"
fi
pathadd() {
    newelement=${1%/}
    if [ -d "$1" ] && ! echo $PATH | grep -E -q "(^|:)$newelement($|:)" ; then
        if [ "$2" = "after" ] ; then
            export PATH="$PATH:$newelement"
        else
            export PATH="$newelement:$PATH"
        fi
    fi
}

pathrm() {
    export PATH="$(echo $PATH | sed -e "s;\(^\|:\)${1%/}\(:\|\$\);\1\2;g" -e 's;^:\|:$;;g' -e 's;::;:;g')"
}


# Don't require escaping globbing characters in zsh.
unsetopt nomatch

# Better default prompt. OhMyZsh (if installed) will replace with a themed prompt
export PS1=$'\n'"%F{green}%~%  %F{yellow}%*%F %3~ %F{white}"$'\n'"$ "

# Bash-style time output.
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# Set architecture-specific brew share path.
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
    share_path="/usr/local/share"
elif [ "${arch_name}" = "arm64" ]; then
    share_path="/opt/homebrew/share"
else
    echo "Unknown architecture: ${arch_name}"
fi

# Allow history search via up/down keys.
source ${share_path}/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# Completions.
autoload -Uz compinit && compinit
# Case insensitive.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'


# Enable plugins.
plugins=(git brew history kubectl history-substring-search)

#################################################################
#                                                               #
#     Oh-My-Zsh configuration (if installed)                    #
#                                                               #
#################################################################
if [ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    export ZSH="$HOME/.oh-my-zsh"
    ZSH_THEME="amuse"

    # run oh-my-zsh to load themes and plugins
    source "$ZSH/oh-my-zsh.sh"
fi

# Include alias file (if present) containing aliases for ssh, etc.
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"

# Include functions file (if present) containing custom useful functions
[ -f "$HOME/.functions" ] && source "$HOME/.functions"


# SDKMAN manages installed java versions
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
export SDKMAN_OFFLINE_MODE=false

# NVM manages installed node versions
export NVM_DIR="$HOME/.nvm"
# NVM for Intel Macs?
#  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
#  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
# NVM for M1 Macs
#  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
#  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
# NVM for all?
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# M1 homebrew not added to path by default
export PATH=/opt/homebrew/bin:$PATH


# START: Add direnv hook
_direnv_hook() {
  trap -- '' SIGINT;
  eval "$("/opt/homebrew/bin/direnv" export zsh)";
  trap - SIGINT;
}
typeset -ag precmd_functions;
if [[ -z "${precmd_functions[(r)_direnv_hook]+1}" ]]; then
  precmd_functions=( _direnv_hook ${precmd_functions[@]} )
fi
typeset -ag chpwd_functions;
if [[ -z "${chpwd_functions[(r)_direnv_hook]+1}" ]]; then
  chpwd_functions=( _direnv_hook ${chpwd_functions[@]} )
fi
# END: Add direnv hook

# Created by `pipx` on 2022-03-29 12:09:44
export PATH="$PATH:/Users/jack/Library/Python/3.9/bin"


export ANDROID_HOME=/Users/$USER/Library/Android/sdk

if [ -d "$ANDROID_HOME" ]; then
  export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
fi

# START: Ruby installed by brew
pathadd "/opt/homebrew/opt/ruby/bin"
# For compilers to find ruby you may need to set:
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
for file in /opt/homebrew/lib/ruby/gems/*/gems/*/bin; do
  if [ -e "$file" ] ; then
     pathadd "$file"
  fi
done
# END: Ruby installed by brew

# add webstorm to path if installed
pathadd "/Applications/WebStorm.app/Contents/MacOS"

