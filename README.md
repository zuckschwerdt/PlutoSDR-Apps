## PlutoSDR-Apps -- Prebuilt SDR applications for ADALM-PLUTO SDR

[Prebuilt binaries](https://github.com/zuckschwerdt/PlutoSDR-Apps/releases) of some useful SDR applications for the PlutoSDR.

- Chrony
- GPSd
- SoapySDR
- SoapyRemote
- SoapyPlutoSDR
- rx_tools
- rtl_433

Suggestions which other apps and libs to include are welcome.

## Notes on toolchains

There are multiple toolchains that work.

On Debian 9 the arm-linux-gnueabi to build for plutosdr-fw 0.29 (and earlier)
and arm-linux-gnueabihf-gcc to build for plutosdr-fw v0.30 (or higher) is a good choice.

For Travis builds on Ubuntu the Linaro toolchains are used.

### For plutosdr-fw up to 0.29:

Zynq-7000 (CodeSourcery - soft float) from Vivado SDK 2017.2 (restricted download):
- `/opt/Xilinx/SDK/2017.2/gnu/arm/lin/bin/arm-xilinx-linux-gnueabi-gcc` (Sourcery CodeBench Lite 2015.05-17) 4.9.2

The GCC 6 soft-float toolchain arm-linux-gnueabi from Debian 9. (May need `CXXFLAGS='-D_GLIBCXX_USE_CXX11_ABI=0'` to target the correct ABI)

The Linaro gcc-linaro-4.9-2016.02 toolchain.

### For plutosdr-fw v0.30 and up:

Zynq-7000 (Linaro - hard float) from Vivado SDK 2017.4 (restricted download):
- `/opt/Xilinx/SDK/2017.4/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin/arm-linux-gnueabihf-gcc` (Linaro GCC Snapshot 6.2-2016.11) 6.2.1 20161114

The GCC 6 hard-float toolchain arm-linux-gnueabihf-gcc from Debian 9.

The Linaro gcc-linaro-6.2-2016.11 toolchain.
