# Libimobiledevice build script

a bash script to build libimobiledevice, libimobiledevice-glue, libplist, libusbmuxd, usbmuxd

## Usage

首先使用 `download.sh` 脚本下载所有依赖库

然后执行(windows需要下载 msys2 运行脚本)

```bash
./build.sh build all
```
或者只编译单个库，但是库可能需要依赖其他库，依赖关系在 build.sh 中有描述
```bash
./build.sh build libimobiledevice
```

编译完成后，安装目录为 `libxxxx/__install`

```bash
./build.sh clean all
./build.sh clean libimobiledevice
```
执行 `make clean`