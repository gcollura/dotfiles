echo "Installing..."
cp Xresources ~/.Xresources
cp Xcolors    ~/.config/Xcolors

xrdb -merge ~/.Xresources
echo "Done."
