eval "$(/opt/homebrew/bin/brew shellenv)"
# source $(brew --prefix nvm)/nvm.sh

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
