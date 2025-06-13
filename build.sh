#!/bin/bash

LOCAL_DIR=$(dirname "$0")
LOCAL_DIR=$(cd "$LOCAL_DIR" && pwd)

INSTALL_DIR_NAME='__install'
export PKG_CONFIG_PATH="$LOCAL_DIR"
for d in $(ls $LOCAL_DIR); do
    if [ -d "$d" ]; then
        export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$LOCAL_DIR/$d/$INSTALL_DIR_NAME/lib/pkgconfig"
    fi
done

echo "PKG_CONFIG_PATH set to: $PKG_CONFIG_PATH"

install_win_deps() {
    echo "Installing dependencies for Windows..."

    # pacman -Syu
    pacman -S --needed mingw-w64-x86_64-toolchain mingw-w64-x86_64-cython mingw-w64-x86_64-libzip
    pacman -S --needed base-devel cython msys2-devel git make automake autoconf libtool pkgconf openssl openssl-devel libcurl
}

install_linux_deps() {
    echo "Installing dependencies for Linux..."

    sudo apt-get install build-essential pkg-config checkinstall git autoconf automake libtool-bin libssl-dev
}

install_macos_deps() {
    echo "Installing dependencies for MacOS..."

    brew install autoconf automake libtool pkg-config openssl
}

# 根据平台安装对应的依赖
install_deps() {
    local os=$(uname)
    echo "Installing dependencies for $os..."
    case $os in
        Linux*)
            install_linux_deps
            ;; 
        Darwin*)
            install_macos_deps
            ;; 
        MINGW*)
            install_win_deps
            ;; 
        CYGWIN*)
            install_win_deps
            ;; 
        *)
            echo "Unsupported platform: $os"
            ;; 
    esac
}


build_mod() {
    echo
    local name="$1"
    local dir="$LOCAL_DIR/$name"
    if [ -d "$dir" ]; then
        echo "Building $name..."
        cd "$dir"
        ./autogen.sh --prefix="$dir/$INSTALL_DIR_NAME" || exit 1
        make -j8 || exit 1
        make install || exit 1
        echo
        echo ">>>> $name built successfully."
    else
        echo "Directory $dir does not exist."
    fi
}

clean_mod() {
    echo
    local name="$1"
    local dir="$LOCAL_DIR/$name"
    if [ -d "$dir" ]; then
        echo "Cleaning $name..."
        cd "$dir"
        make clean
        echo
        echo ">>>> $name cleaned successfully."
    else
        echo "Directory $dir does not exist."
    fi
}

print_usage() {
    echo "Usage: build.sh clean all"
    echo "Usage: build.sh clean libplist"
    echo "Usage: build.sh build all"
    echo "Usage: build.sh build libplist"
}

# 编译 libimobiledevice
# 依赖关系
# libplist
# libimobiledevice-glue
#    |_ libplist
# libusbmuxd
#    |_ libimobiledevice-glue
#    |_ libplist
# libtatsu
#    |_ libplist
# libimobiledevice
#    |_ libplist
#    |_ libimobiledevice-glue
#    |_ libusbmuxd
#    |_ libtatsu
# usbmuxd
#    |_ libusb
#    |_ libimobiledevice

install_deps

all_modules=('libplist' 'libimobiledevice-glue' 'libusbmuxd' 'libtatsu' 'libimobiledevice' 'libusb' 'usbmuxd')

case "$1" in
    'clean')
        shift
        if [ $# -eq 0 ]; then
            print_usage
            exit 1
        fi
        if [ "$1"  = 'all' ]; then
            for module in "${all_modules[@]}"; do
                clean_mod $module
            done
        else
            clean_mod $1
        fi
        exit 0
        ;;
    'build')
        shift
        if [ $# -eq 0 ]; then
            print_usage
            exit 1
        fi
        if [ "$1"  = 'all' ]; then
            for module in "${all_modules[@]}"; do
                build_mod $module
            done
        else
            build_mod $1
        fi
        ;;
    *)
        print_usage
        exit 1
        ;;
esac