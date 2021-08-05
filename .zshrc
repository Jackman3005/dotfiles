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
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
