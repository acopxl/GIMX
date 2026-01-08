#!/bin/sh

DESTDIR="$PWD/AppDir"
rm -rf "$DESTDIR" 
rm -rf ./linuxdeploy-x86_64.AppImage*

mkdir -p "$DESTDIR"
make install DESTDIR="$DESTDIR"

### Modify installation
# Munge the desktop file to not use absolute paths or pkexec
sed -i \
    -e 's+^Exec=.*+Exec=gimx-launcher+' \
    -e 's+^Name=.*+Name=Gimx-launcher+' \
    "$DESTDIR"/usr/share/applications/gimx-launcher.desktop


# get linuxdeploy's AppImage
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
chmod +x linuxdeploy-x86_64.AppImage

# run linuxdeploy and generate an AppDir
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:$PWD/AppDir/usr/lib"
./linuxdeploy-x86_64.AppImage --appdir AppDir --output appimage --desktop-file "$DESTDIR/usr/share/applications/gimx-launcher.desktop" --verbosity=1
