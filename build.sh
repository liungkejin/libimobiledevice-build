#!/bin/bash

LOCAL_DIR=$(dirname "$0")
LOCAL_DIR=$(cd "$LOCAL_DIR" && pwd)

export PKG_CONFIG_PATH="$LOCAL_DIR"
for d in $(ls $LOCAL_DIR); do
    if [ -d "$d" ]; then
        export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$LOCAL_DIR/$d/install/lib/pkgconfig"
    fi
done

echo "PKG_CONFIG_PATH set to: $PKG_CONFIG_PATH"

build_mod() {
    local name="$1"
    local dir="$LOCAL_DIR/$name"
    if [ -d "$dir" ]; then
        echo "Building $name..."
        cd "$dir"
        make clean
        ./autogen.sh --prefix="$dir/install" || exit 1
        make -j8 || exit 1
        make install || exit 1
        echo
        echo ">>>> $name built successfully."
    else
        echo "Directory $dir does not exist."
    fi
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

if [ "$1" = 'all' ]; then
    build_mod libplist
    build_mod libimobiledevice-glue
    build_mod libusbmuxd
    build_mod libtatsu
    build_mod libimobiledevice
else
    if [ -z "$1" ]; then
        echo "Usage: $0 <module_name> or $0 all"
        exit 1
    fi
fi
build_mod $1