#!/bin/bash

gitclone() {
    local repo_url="$1"
    local dest_dir="$2"
    if [ -d "$dest_dir" ]; then
        echo "Directory $dest_dir already exists. Skipping clone."
    else
        echo "Cloning $repo_url into $dest_dir..."
        git clone "$repo_url" "$dest_dir" || exit 1
    fi
}
# LOCAL_DIR=$(dirname "$0")
# LOCAL_DIR=$(cd "$LOCAL_DIR" && pwd)

gitclone "https://github.com/libimobiledevice/libimobiledevice.git" "libimobiledevice"
gitclone "https://github.com/libimobiledevice/libimobiledevice-glue.git" "libimobiledevice-glue"
gitclone "https://github.com/libimobiledevice/libplist.git" "libplist"
gitclone "https://github.com/libimobiledevice/libtatsu.git" "libtatsu"
gitclone "https://github.com/libimobiledevice/libusbmuxd.git" "libusbmuxd"
gitclone "https://github.com/libimobiledevice/usbmuxd.git" "usbmuxd"
gitclone "https://github.com/libusb/libusb.git" "libusb"