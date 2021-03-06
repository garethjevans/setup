#~/usr/bin/env zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

for file in ~/.{aliases,functions,path,exports}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		# shellcheck source=/dev/null
		source "$file"
	fi
done
unset file

## gpg
export GPG_TTY=$TTY
gpg-connect-agent updatestartuptty /bye > /dev/null
unset SSH_AGENT_PID
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

## oh-my-zsh
if [ ! -d $ZSH/custom/plugins/zsh-syntax-highlighting ] && [ -d $ZSH ]
then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting
fi

if [ -d $ZSH ]
then
  plugins=(git vi-mode kubectl zsh-syntax-highlighting golang tmux z)
  source $ZSH/oh-my-zsh.sh
  if [ -r /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme ]
  then
    source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme
  fi
fi

# If you have a set of personal aliases separated out, load them in here
[ -f ~/.custom_aliases ] && source ~/.custom_aliases

# If you have a set of personal exported vars separated out, load them in here
[ -f ~/.custom_exports ] && source ~/.custom_exports

# If you have a set of personal functions, load them in here
[ -f ~/.custom_functions ] && source ~/.custom_functions
## completions
# jx command completion
if [ $(command -v jx) ]
then
  source <(jx completion zsh)
fi
if [ $(command -v dx) ]
then
  source <(dx completion -s zsh)
fi
compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# p10k customoisations
typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|kind|aws'
typeset -g POWERLEVEL9K_TIME_FOREGROUND=160

# Fixed issue #31 https://github.com/cagiti/setup/issues/31
if alias ksd >/dev/null; then
  unalias ksd
fi

# asdf
command -v asdf 1>/dev/null && . /usr/local/opt/asdf/asdf.sh || echo "asdf is not installed"

eval "$(direnv hook $SHELL)"
. ~/.asdf/plugins/java/set-java-home.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
