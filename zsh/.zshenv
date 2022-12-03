export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

# For dotfiles
export XDG_CONFIG_HOME="$HOME/.config"
# For user specific data
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
# For user cached files
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

export EDITOR="nvim"
export VISUAL="nvim"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# History filepath
export HISTFILE="$ZDOTDIR/.zhistory"
# Maximum events for internal history
export HISTSIZE=10000
# Maximum events in history file
export SAVEHIST=10000

export DOTFILES="$HOME/dotfiles"

# fzf and ripgrep
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export SOPS_AGE_KEY_FILE="$XDG_CONFIG_HOME/sops/age/keys.txt"
