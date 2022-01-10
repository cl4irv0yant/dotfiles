export XDG_CONFIG_HOME="$HOME/.config"
export LOCAL_HOME="$HOME/.local"
export XDG_CACHE_HOME="$LOCAL_HOME/cache"
export XDG_DATA_HOME="$LOCAL_HOME/share"
export XDG_STATE_HOME="$LOCAL_HOME/state"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export HISTFILE="$ZDOTDIR/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000

export QT_SCALE_FACTOR=2
export GDK_SCALE=2

alias mitmproxy="mitmproxy --set confdir=$XDG_CONFIG_HOME/mitmproxy"
alias mitmweb="mitmweb --set confdir=$XDG_CONFIG_HOME/mitmproxy"

export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git'"
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod 
export GOPATH="$XDG_DATA_HOME"/go
export K9SCONFIG="$XDG_CONFIG_HOME"/k9s 
export TEXMFHOME=$XDG_DATA_HOME/texmf 
export TEXMFVAR=$XDG_CACHE_HOME/texlive/texmf-var 
export TEXMFCONFIG=$XDG_CONFIG_HOME/texlive/texmf-config
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc 
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc

export STATE="$HOME/State"
export DOTFILES="$STATE/src/dotfiles"
export NOTES_HOME="$HOME/notes"
export INSTALLER="$DOTFILES/arch_install"
export PATH="$DOTFILES/scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export NEWSBOAT_URLS_FILE="$NOTES_HOME/newsboat_urls"

export EDITOR="nvim"
export BROWSER=$(command -v firefox)
export VISUAL="nvim"
export R_HOME_USER="$HOME/.config/R"
export R_PROFILE_USER="$HOME/.config/R/profile"
export R_HISTFILE="$HOME/.config/R/history"
export KUBECONFIG="$XDG_CONFIG_HOME/kube"

export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java 
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker 
