export HOMEBREW_NO_ENV_HINTS=1
command -v brew &>/dev/null && eval "$(/opt/homebrew/bin/brew shellenv)"
# source $(brew --prefix nvm)/nvm.sh

export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv &>/dev/null ; then
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
fi
