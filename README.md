Xiaomi Redmi Note 3 Kernel Build mini-Howto
===========================================

1. Build
--------

- get toolchain
    From android git server, codesourcery etc.
	(preferably android NDK)
    - `aarch64-linux-android-4.9`

- Unpack kernel source
    Suppose kernel source has been unpacked to `<kernel>` dir.

- export env variables
    export correct `CROSS_COMPILE` to use the toolchain path you have downloaded.
    (assuming that ndk is extracted to /home and is renamed to "toolchain")
```
 export CROSS_COMPILE="/home/$USER/toolchain/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-"
```

```
 export JOBS=16    # Can be CPU core # x 2
```

- build kernel

```
 cd <kernel>
```

```
 make -C $PWD O=$PWD/out ARCH=arm64 cyanogenmod_kenzo_defconfig
```

```
 make -j$JOBS -C $PWD O=$PWD/out ARCH=arm64 KCFLAGS=-mno-android
```

```
 make -j$JOBS -C $PWD O=$PWD/out ARCH=arm64 KCFLAGS=-mno-android modules
```

2. Output files
---------------

- Kernel: `out/arch/arm64/boot/Image`
- Kernel modules: `out/drivers/*/*.ko`

3. Clean up
-----------

```
sudo rm -rf out
```