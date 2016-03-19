echo "Updating submodules"

git submodule update --init

echo "Creating symlinks"

set -x

ln -s $PWD/tmux.conf ~/.tmux.conf
ln -s $PWD/tmux ~/.tmux
# ln -s $PWD/irssi ~/.irssi
ln -s $PWD/vim ~/.vim
ln -s $PWD/xdefaults/Xresources ~/.Xresources
# ln -s $PWD/xdefaults/Xcolors.atelier ~/.config
ln -s $PWD/eclimrc ~/.eclimrc
ln -s $PWD/gitignore ~/.config/git/ignore
