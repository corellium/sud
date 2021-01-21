# sud(aemon)

## What is this?

`sud` is a simplistic `su` daemon for Corellium, and maybe other, Android devices. It is older [Superuser](https://github.com/koush/Superuser) code, slightly refactored and heavily stripped down to the pure basics. Simply put, it will allow anyone who requests for `su` to be granted it. This is *not* something you should run on your personal device, this is a huge security issue. However if you want to test things or allow anything to run with `root` privledges, this is for you. This binary could also be easily modified to log all incoming `su` requests for such things as simplistic "taint" trace or watching what binaries use it for.

### Build

Building should be rather simple, simply modify the `Makefile.local` file to properly point to you compiled of choice (`CC`) and system root (`SYSROOT`). These are located inside your Android NDK (`ANDROID_NDK`) directory for most people. I've left my `Makefile.local` commited to what it would be on my builder as an example. Once this is done, simply run `make`.

```
diff@larry:../sud/ $ make
~/Android/Sdk/ndk/20.0.5594570/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android24-clang -o src/daemon.o src/daemon.c -c -O2 -Wall -Wextra -I./include/ 
~/Android/Sdk/ndk/20.0.5594570/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android24-clang -o src/pts.o src/pts.c -c -O2 -Wall -Wextra -I./include/ 
~/Android/Sdk/ndk/20.0.5594570/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android24-clang -o src/su.o src/su.c -c -O2 -Wall -Wextra -I./include/ 
~/Android/Sdk/ndk/20.0.5594570/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android24-clang -o bin/su src/daemon.o src/pts.o src/su.o -llog 
diff@larry:../sud/ $ ls -l bin 
total 44
-rwxrwxr-x 1 diff diff 41416 Jan 21 13:31 su
```

Alternatively, check the releases tab for a precompiled `su` binary.

### Installing on Corellium Android Devices

Build the binaries in this repository following the directions in the `Build` section. Then on
the local machines connect to the device via `adb` and push the following files;

```
adb push init.sud.rc /data/local/tmp/
adb push bin/su /data/local/tmp/
```

Then get a `shell`, via `adb` and run the following commands;

```
su
/system/bin/mount -orw,remount /system
/vendor/bin/cp /data/local/tmp/su /system/xbin/su
/vendor/bin/chown root /system/xbin/su
/system/bin/chcon u:object_r:su_exec:s0 /system/xbin/su
/vendor/bin/chmod 06755 /system/xbin/su

/vendor/bin/cp /data/local/tmp/init.sud.rc /system/etc/init/init.sud.rc
/vendor/bin/chown root /system/etc/init/init.sud.rc
/system/bin/chcon u:object_r:system_file:s0 /system/etc/init/init.sud.rc
/vendor/bin/chmod 644 /system/etc/init/init.sud.rc

/system/bin/reboot
```

## License

These files are a mash-up and refactor from a number of sources. We've retained both the
licensing from all those files and added ourselves to any files modified. If we've somehow
missed anyone from the files in the transition, please submit a pull request and we will
fix it as soon as possible!

```
   Copyright 2020, Corellium, LLC
   Copyright 2013, Tan Chee Eng (@tan-ce)
   Copyright 2010, Adam Shanks (@ChainsDD)
   Copyright 2008, Zinx Verituse (@zinxv)
  
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
```