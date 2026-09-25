# NetHunter Kernel v4.2 — SM-A325 variants, SM-A225 variants, SM-E225F and SM-M225FV

Custom NetHunter-ready kernel built for stability, performance tuning, and external adapter penetration testing.

---

## [Download from Google Drive A32](https://drive.google.com/drive/folders/1-WTgc8WdROdaQjSQCMAMkMX8YOPUw8yN?usp=drive_link)
## [Download from Google Drive A22](https://drive.google.com/drive/folders/1_725Sk8eJ_97ctm967O_CFGTl7GvcN4w?usp=drive_link)
## [Download from Google Drive F22](https://drive.google.com/drive/folders/1YPi3GAk-PEPLbTFX38_qPiQfWowE7GWa?usp=drive_link)
## [Download from Google Drive M32](https://drive.google.com/drive/folders/1ix-UFToKluOMuJOvIOX6acx9EjLs4_wO?usp=drive_link)
## [Kernel Source](https://github.com/Samsung-MT6769-Devs/android_kernel_samsung_mt6768)

---

## Disclaimer

This kernel is unofficial and intended strictly for **development, security research, and educational use**.
You accept full responsibility for anything that happens to your device, data, or network.

Not affiliated with Offensive Security or Kali NetHunter.

---

## Key Features

* Integrated **KernelSU Next v3.2.0-legacy** (Working & Tested)
* SELinux **Permissive**
* USB OTG Support
* USB HID Support (Emulating Keyboard and Mouse)
* USB Mass Storage Support
* Wi-Fi Monitor mode and Injection for external adapters
* BT Subsystem support with RFCOMM, HIDP and BNEP (some chipsets may need their firmware in **/vendor/firmware**)
* CANBus Subsystem Support
* NFS Support
* AirSpy
* HackRF
* Mirics MSi2500

---

## Bugs

* Internal Wi-Fi injection not supported (hardware limitation)

---

## Wi-Fi Drivers (USB Only)

**Tested**

* RTL8821CU
* RTL8192EU
* ZD1211/ZD1211B

**Built-in but untested**

* ATH: ATH6KL, AR9170
* MediaTek: MT7601U
* Ralink: RT2x00, RT2500USB, RT2800USB
* Realtek:
  
  * RTL8723D
  * RTL8812A
  * RTL8814A
  * RTL8821A/C
  * RTL8822B/C
  * RTL8192E
* ZyDas: ZD1201, ZD1211/ZD1211B

---

## Supported Devices

* Samsung Galaxy A32 4G (SM-A325 variants) (Tested)
* Samsung Galaxy A22 4G (SM-A225 variants) (Not tested)
* Samsung Galaxy F22 4G (SM-E225F) (Not tested)
* Samsung Galaxy M32 4G (SM-M225FV) (Not tested)

---

## Flash Requirements

* Unlocked bootloader
* Custom recovery (recommended)

[TWRP Build for A32](https://github.com/Luminous418/twrp_device_samsung_a32/releases/tag/TWRP-3.7.0_12.1-a32-20251227) <br>
[TWRP Build for A22](https://xdaforums.com/t/recovery-unofficial-twrp-for-galaxy-a22-sm-a225f-a225m-android-11-12.4333305/) (Not verified working) <br>
[TWRP Build for F22](https://xdaforums.com/t/f22-recovery-unofficial-twrp-3-6-11-recovery-for-f22-4g-sm-e225f-ds.4444187/) (Not verified working) <br>
[TWRP Build for M32](https://xdaforums.com/t/m32-recovery-unofficial-twrp-3-6-11-recovery-for-m32-4g-sm-m325f-fv.4439319/) (Not verified working)

---

## Installation

1. Boot to recovery
2. Install kernel zip
3. Reboot

---

### Dependencies

```
sudo apt update && sudo apt install -y \
git build-essential bc flex bison libssl-dev libelf-dev \
device-tree-compiler lz4 xz-utils zlib1g-dev libncurses-dev \
pahole python3 python-is-python3 openjdk-17-jdk rsync cpio kmod zstd
```

---

### Toolchain

```
git clone https://github.com/karamdev1/zyc-clang-14-20260619.git ~/toolchains/zyc-clang-14-20260619
```

---

### Build

```
./build.sh
```
