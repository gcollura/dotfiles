echo -n "Creating symlinks"

set -x

ln -s $(pwd)/tmux.conf ~/.tmux.conf
ln -s $(pwd)/irssi ~/.irssi
ln -s $(pwd)/vim ~/.vim
