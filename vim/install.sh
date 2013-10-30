echo "Installing random-cpp's vim config distribution"
echo
echo "Copying to $HOME directory. Attention, may overwrite previous configurations."
mkdir -p $HOME/.vim/
#cp vimrc $HOME/.vimrc
#cp gvimrc $HOME/.gvimrc
echo
cp * $HOME/.vim/
cp ycm_extra_conf.py $HOME/.vim/
echo
echo "Cloning Shougo/neobundle.vim"
mkdir -p $HOME/.vim/bundle
git clone git@github.com:Shougo/neobundle.vim.git $HOME/.vim/bundle/neobundle.vim
echo "Updating all plugins"
vim +NeoBundleInstall +q
echo
mkdir -p $HOME/.vim/undo $HOME/.vim/session
echo "Done"
