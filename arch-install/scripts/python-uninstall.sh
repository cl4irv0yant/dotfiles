#!/bin/bash

if [ ! -f $HOME/.zshrc ]; then
    touch $HOME/.zshrc
fi

lines='
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
'
echo "$lines" >> "$HOME/.zshrc"

curl https://pyenv.run | bash

exec bash -l -c '
source $HOME/.zshrc && \
$PYENV_ROOT/bin/pyenv install 3.11 && \
$PYENV_ROOT/bin/pyenv global 3.11 && \
python -m pip install pipx && \
python -m pipx ensurepath && \
pipx install yt-dlp && \
curl -sSL https://install.python-poetry.org | python3 - && \
which python && \
which pipx && \
which yt-dlp && \
which poetry'

echo "Installation complete!"

