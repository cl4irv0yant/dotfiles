fpath=($ZDOTDIR/external $fpath)

if command -v pyenv > /dev/null; then
  eval "$(pyenv init -)"
fi

if [ $(command -v "fzf") ]; then
  source /usr/share/fzf/completion.zsh
  source /usr/share/fzf/key-bindings.zsh
fi

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
_comp_options+=(globdots)

zmodload zsh/complist
autoload -Uz compinit; compinit

autoload -Uz cursor_mode && cursor_mode
autoload -Uz edit-command-line
zle -N edit-command-line
source $DOTFILES/zsh/external/completion.zsh
source $DOTFILES/zsh/external/bd.zsh
source $DOTFILES/zsh/scripts.sh
source $DOTFILES/zsh/external/cursor_mode
source $DOTFILES/zsh/external/prompt_purification_setup
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias mycli='mycli --myclirc $XDG_CONFIG_HOME/myclirc'
alias ll='ls -lah'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias mypy='poetry run mypy'
alias cat=bat
alias ls=exa
alias d='dirs -v'
#for index ({1..9}) alias "$index"="cd +${index}"; unset index
alias visudo="sudo EDITOR=nvim visudo"
alias refresh="make clear-cache && make refresh-db"

alias tne="tailscale up --exit-node= --accept-routes"
alias te="tailscale up --exit-node= --accept-routes --exit-node-allow-lan-access"

bindkey -v
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M vicmd v edit-command-line
bindkey -M vicmd 'p' paste-from-clipboard
bindkey -r '^l'
bindkey -r '^g'
bindkey -s '^g' 'clear\n'
export KEYTIMEOUT=1

# Define the widget to paste from clipboard
paste-from-clipboard() {
  LBUFFER+=$(xclip -o -selection clipboard)
}
zle -N paste-from-clipboard


if [ "$(tty)" = "/dev/tty1" ]; then
  pgrep i3 || exec startx "$XDG_CONFIG_HOME/X11/.xinitrc"
fi

ftmuxp
