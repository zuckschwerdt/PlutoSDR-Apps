#!/bin/sh

set -e

# note: sysroot up to 0.29 needs a soft-float compiler, sysroot 0.30 and above a hard-float compiler
#PLUTOSDRFW=${PLUTOSDRFW:-v0.29}
PLUTOSDRFW=${PLUTOSDRFW:-v0.30}
#VENDOR=xilinx-
#CROSS_COMPILE=arm-${VENDOR}linux-gnueabi-
#TARGET=${TARGET:-arm-linux-gnueabi}
TARGET=${TARGET:-arm-linux-gnueabihf}
export CROSS_COMPILE=${CROSS_COMPILE:-${TARGET}-}
#export tools=/opt/Xilinx/SDK/2017.2/gnu/arm/lin
#export tools=/opt/Xilinx/SDK/2017.4/gnu/aarch32/lin/gcc-arm-linux-gnueabi
export tools=$(pwd)/gcc-linaro-6.2.1-2016.11-x86_64_arm-linux-gnueabihf
export PATH=${tools}/bin:$PATH
export SYSROOT=$(pwd)/sysroot
export STAGING=$(pwd)/stage

echo Getting plutosdr-fw ${PLUTOSDRFW}
[ -e sysroot-${PLUTOSDRFW}.tar.gz ] || wget https://github.com/analogdevicesinc/plutosdr-fw/releases/download/${PLUTOSDRFW}/sysroot-${PLUTOSDRFW}.tar.gz
echo Setting up sysroot
tar xzf sysroot-${PLUTOSDRFW}.tar.gz
mv staging ${SYSROOT}
mkdir ${STAGING}

echo Building Chrony
[ -e chrony ] || git clone https://git.tuxfamily.org/chrony/chrony.git
cd chrony
bison -o getdate.c getdate.y
CC=${CROSS_COMPILE}gcc CFLAGS="--sysroot ${SYSROOT}" ./configure
CC=${CROSS_COMPILE}gcc CFLAGS="--sysroot ${SYSROOT}" make
mkdir -p ${STAGING}/bin/
cp chronyc chronyd ${STAGING}/bin/
make clean
cd ..

echo Building GPSd
[ -e gpsd ] || git clone git://git.savannah.gnu.org/gpsd.git
cd gpsd
cat >.scons-option-cache <<EOF
libgpsmm = False
ncurses = False
python = False
dbus_export = False
bluez = False
qt = False
prefix = '${STAGING}'
sysroot = '${SYSROOT}'
target = '${TARGET}'
EOF
scons install
scons --clean ; rm .sconsign.dblite
cd ..

echo Building SoapySDR
[ -e SoapySDR ] || git clone https://github.com/pothosware/SoapySDR.git
cd SoapySDR
git checkout soapy-sdr-0.7.1
mkdir build ; cd build ; cmake -DCMAKE_TOOLCHAIN_FILE=../../Toolchain.cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .. && make install ; cd ..
rm -r build
cd ..

echo Building SoapyRemote
[ -e SoapyRemote ] || git clone https://github.com/pothosware/SoapyRemote.git
cd SoapyRemote
mkdir build ; cd build ; cmake -DCMAKE_TOOLCHAIN_FILE=../../Toolchain.cmake -DSoapySDR_DIR=${STAGING}/share/cmake/SoapySDR .. && make && make install ; cd ..
rm -r build
cd ..

echo Building SoapyPlutoSDR
[ -e SoapyPlutoSDR ] || git clone https://github.com/pothosware/SoapyPlutoSDR.git
cd SoapyPlutoSDR
mkdir build ; cd build ; cmake -DCMAKE_TOOLCHAIN_FILE=../../Toolchain.cmake -DSoapySDR_DIR=${STAGING}/share/cmake/SoapySDR .. && make && make install ; cd ..
rm -r build
cd ..

echo Building rx_tools
[ -e rx_tools ] || git clone https://github.com/rxseger/rx_tools.git
cd rx_tools
mkdir build ; cd build ; cmake -DCMAKE_TOOLCHAIN_FILE=../../Toolchain.cmake -DSoapySDR_DIR=${STAGING}/share/cmake/SoapySDR .. && make && make install ; cd ..
rm -r build
cd ..

echo Building rtl_433
[ -e rtl_433 ] || git clone https://github.com/merbanan/rtl_433.git
cd rtl_433
mkdir build ; cd build ; cmake -DCMAKE_TOOLCHAIN_FILE=../../Toolchain.cmake -DSoapySDR_DIR=${STAGING}/share/cmake/SoapySDR .. && make && make install ; cd ..
rm -r build
cd ..

echo Packing binaries
cd ${STAGING}
7zr a ../plutosdr-apps.zip bin sbin lib etc
cd ..
tar czf plutosdr-apps.tar.gz -C ${STAGING} bin sbin lib etc
