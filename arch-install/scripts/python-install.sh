#!/bin/bash


curl https://pyenv.run | bash

exec bash -l -c '
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

