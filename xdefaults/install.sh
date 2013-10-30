echo "Installing..."
cp Xresources ~/.Xresources
cp Xcolors*    ~/.config/

xrdb -merge ~/.Xresources
echo "Done."
