#!/bin/sh

# installs GCC 6 cross compiler toolchain on Debian 9
# run with sudo

apt-get install -y cmake bison scons
apt-get install -y gcc-arm-linux-gnueabi g++-arm-linux-gnueabi
apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf

# junk glibc to prevent version conflicts
# libc6-armel-cross
# libstdc++-6-dev-armel-cross
rm $(dpkg -L libc6-dev-armel-cross)
rm $(dpkg -L linux-libc-dev-armel-cross)
rm $(dpkg -L libstdc++6-armel-cross)
# libc6-armhf-cross
# libstdc++-6-dev-armhf-cross
rm $(dpkg -L libc6-dev-armhf-cross)
rm $(dpkg -L linux-libc-dev-armhf-cross)
rm $(dpkg -L libstdc++6-armhf-cross)

# perhaps this is sufficient. not tested.
# rm /usr/arm-linux-gnueabi*/lib/libstdc++.so.6
# rm /usr/arm-linux-gnueabi*/lib/libc.so

exit 0
