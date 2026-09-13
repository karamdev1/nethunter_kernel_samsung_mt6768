#!/bin/bash

BOLDGREEN="\e[1;32m"
BOLDRED="\e[1;31m"
BOLDCYAN="\e[1;36m"
BOLDBLUE="\e[1;94m"
BOLDYELLOW="\e[1;33m"
ENDCOLOR="\e[0m"

if [ ! -f config.cfg ]; then
    echo "${BOLDRED}[-] config file not found$ENDCOLOR"
    exit 1
fi

source config.cfg

if [[ ! $ARCH ]] then
	echo -e "${BOLDRED}[-] ARCH is empty or not set!$ENDCOLOR"
	exit 1
fi
if [[ ! $TD ]] then
	echo -e "${BOLDRED}[-] TD is empty or not set!$ENDCOLOR"
	exit 1
fi
if [[ ! $BIN_PATH ]] then
	echo -e "${BOLDRED}[-] BIN_PATH is empty or not set!$ENDCOLOR"
	exit 1
fi
if [[ ! $CC ]] then
	echo -e "${BOLDRED}[-] CC is empty or not set!$ENDCOLOR"
	exit 1
fi
if [[ ! $CLANG_TRIPLE ]] then
	echo -e "${BOLDRED}[-] CLANG_TRIPLE is empty or not set!$ENDCOLOR"
	exit 1
fi
if [[ ! $CROSS_COMPILE ]] then
	echo -e "${BOLDRED}[-] CROSS_COMPILE is empty or not set!$ENDCOLOR"
	exit 1
fi
BIN_PATH=$BIN_PATH
export PATH="$BIN_PATH:$PATH"
export ARCH=$ARCH
export CC=$CC
export CLANG_TRIPLE=$CLANG_TRIPLE
export CROSS_COMPILE=$CROSS_COMPILE
if [[ $CROSS_COMPILE_ARM32 ]] then
	export CROSS_COMPILE_ARM32=$CROSS_COMPILE_ARM32
fi
if [[ $KCFLAGS ]] then
	export KCFLAGS=$KCFLAGS
fi
if [[ $KCPPFLAGS ]] then
	export KCPPFLAGS=$KCPPFLAGS
fi
if [[ $ANDROID_MAJOR_VERSION ]] then
	export ANDROID_MAJOR_VERSION=$ANDROID_MAJOR_VERSION
fi
if [[ ! $SECTION_MISMATCH_WARN_ONLY ]] then
	echo -e "${BOLDRED}[-] SECTION_MISMATCH_WARN_ONLY is empty or not set!$ENDCOLOR"
	exit 1
fi
if [[ $ENV ]] then
	export BUILDER_ENV=$ENV
fi

case $SECTION_MISMATCH_WARN_ONLY in
	y)
		export CONFIG_SECTION_MISMATCH_WARN_ONLY=y
		BUILDER_ENV_2="CONFIG_SECTION_MISMATCH_WARN_ONLY=y"
		;;
	e)
		export CONFIG_SECTION_MISMATCH=y
		export CONFIG_SECTION_MISMATCH_WARN_ONLY=n
		BUILDER_ENV_2="CONFIG_SECTION_MISMATCH=y"
		;;
	n)
		BUILDER_ENV_2=""
		;;
esac
OUT_DIR=$OUT_DIR
MODULES_OUT_DIR=$MODULES_OUT_DIR
KDIR=$(pwd)

function show_gui() {
	CCVersion=$($CC --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
	if [ -f "$KDIR/$OUT_DIR/.config" ]; then
		CONFIG_STATUS="${BOLDGREEN}Config present$ENDCOLOR"
	else
		CONFIG_STATUS="${BOLDRED}No .config found$ENDCOLOR"
	fi
	clear
	echo -e "$BOLDBLUE"
	echo -e "\t┌─────────────────────────────────────────────────────┐"
    echo -e "\t│  ██╗  ██╗███████╗██████╗ ███╗   ██╗███████╗██╗      │"
    echo -e "\t│  ██║ ██╔╝██╔════╝██╔══██╗████╗  ██║██╔════╝██║      │"
    echo -e "\t│  █████╔╝ █████╗  ██████╔╝██╔██╗ ██║█████╗  ██║      │"
    echo -e "\t│  ██╔═██╗ ██╔══╝  ██╔══██╗██║╚██╗██║██╔══╝  ██║      │"
    echo -e "\t│  ██║  ██╗███████╗██║  ██║██║ ╚████║███████╗███████╗ │"
    echo -e "\t│  ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝ │"
    echo -e "\t├─────────────────────────────────────────────────────┤"
    echo -e "\t│          B U I L D E R   V 2 . 1                    │"
    echo -e "\t├─────────────────────────────────────────────────────┤$ENDCOLOR"
	echo -e "\t$BOLDBLUE│$ENDCOLOR                     STATUS                          $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE├─────────────────────────────────────────────────────┤$ENDCOLOR"
	echo -e "\t$BOLDBLUE│${BOLDCYAN}By: ${BOLDYELLOW}Karam (karamdev1)$ENDCOLOR                                $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE│${BOLDCYAN}Version: ${BOLDYELLOW}v2.1$ENDCOLOR                                        $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE│                                                     │$ENDCOLOR"
	echo -e "\t$BOLDBLUE│${BOLDCYAN}ARCH: $BOLDYELLOW${ARCH}$ENDCOLOR                                          $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE│${BOLDCYAN}CC Version: ${BOLDYELLOW}$CCVersion$ENDCOLOR                                   $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE│${BOLDCYAN}CLANG_TRIPLE: ${BOLDYELLOW}$(basename $CLANG_TRIPLE)$ENDCOLOR                     $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE│${BOLDCYAN}CROSS_COMPILE: ${BOLDYELLOW}$(basename $CROSS_COMPILE)$ENDCOLOR                    $BOLDBLUE│$ENDCOLOR"
	if [[ $CROSS_COMPILE_ARM32 ]] then
		echo -e "\t$BOLDBLUE│${BOLDCYAN}CROSS_COMPILE_ARM32: ${BOLDYELLOW}$(basename $CROSS_COMPILE_ARM32)$ENDCOLOR              $BOLDBLUE│$ENDCOLOR"
	fi
	echo -e "\t$BOLDBLUE│${BOLDCYAN}Kernel Config: ${CONFIG_STATUS}$ENDCOLOR                      $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE│                                                     │$ENDCOLOR"
	echo -e "\t$BOLDBLUE├─────────────────────────────────────────────────────┤$ENDCOLOR"
	echo -e "\t$BOLDBLUE│$ENDCOLOR                      KERNEL                         $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE├─────────────────────────────────────────────────────┤$ENDCOLOR"
	echo -e "\t$BOLDBLUE│$ENDCOLOR[${BOLDCYAN}1$ENDCOLOR] Compile Kernel from scratch                      $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE│$ENDCOLOR[${BOLDCYAN}2$ENDCOLOR] Compile Kernel from last run                     $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE│$ENDCOLOR[${BOLDCYAN}3$ENDCOLOR] Compile Module     $BOLDCYAN(Auto prepares!)$ENDCOLOR              $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE│$ENDCOLOR[${BOLDCYAN}4$ENDCOLOR] Prepare Module                                   $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE│$ENDCOLOR[${BOLDCYAN}5$ENDCOLOR] Copy Modules       $BOLDCYAN(Compile First!)$ENDCOLOR              $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE│$ENDCOLOR[${BOLDCYAN}6$ENDCOLOR] Apply Defconfig                                  $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE│$ENDCOLOR[${BOLDCYAN}7$ENDCOLOR] Edit Config                                      $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE│$ENDCOLOR[${BOLDCYAN}8$ENDCOLOR] Save config as new defconfig                     $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE│$ENDCOLOR[${BOLDCYAN}0$ENDCOLOR] Clean Environment                                $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE│                                                     │$ENDCOLOR"
	echo -e "\t$BOLDBLUE├─────────────────────────────────────────────────────┤$ENDCOLOR"
	echo -e "\t$BOLDBLUE│$ENDCOLOR                      OTHER                          $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE├─────────────────────────────────────────────────────┤$ENDCOLOR"
	echo -e "\t$BOLDBLUE│$ENDCOLOR[${BOLDRED}E$ENDCOLOR] Exit Builder                                     $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE│$ENDCOLOR[${BOLDCYAN}G$ENDCOLOR] Open the creator's github page                   $BOLDBLUE│$ENDCOLOR"
	echo -e "\t$BOLDBLUE└─────────────────────────────────────────────────────┘$ENDCOLOR"
	echo
}

function compileKernel() {
	echo -e "$BOLDGREEN[+] Building$ENDCOLOR"
	if [ ! -f "$KDIR/$OUT_DIR/.config" ]; then
		echo -e "$BOLDRED[-] No .config found$ENDCOLOR"
	else
		echo -e "$BOLDGREEN[+] .config found$ENDCOLOR"
		make -s -C "$KDIR" O="$OUT_DIR" $BUILDER_ENV $BUILDER_ENV_2 -j"$(nproc)"
		ret=$?
		if [ $ret -eq 0 ]; then
			echo -e "$BOLDGREEN[+] Kernel Building Succeed$ENDCOLOR"
		else
			echo -e "$BOLDRED[-] Kernel Building Failed (exit code: $ret)$ENDCOLOR"
		fi
	fi
}

function compileModules() {
	echo -e "$BOLDGREEN[+] Building Modules$ENDCOLOR"
	if [ ! -f "$KDIR/$OUT_DIR/.config" ]; then
		echo -e "$BOLDRED[-] No .config found$ENDCOLOR"
	else
		echo -e "$BOLDGREEN[+] .config found$ENDCOLOR"
		make -s -C "$KDIR" O="$OUT_DIR" INSTALL_MOD_PATH="$MODULES_OUT_DIR" $BUILDER_ENV $BUILDER_ENV_2 modules -j"$(nproc)"
		ret=$?
		if [ $ret -eq 0 ]; then
			echo -e "$BOLDGREEN[+] Modules Building Succeed$ENDCOLOR"
			echo -e "$BOLDGREEN[+] You can find the modules in $MODULES_OUT_DIR$ENDCOLOR"
		else
			echo -e "$BOLDRED[-] Modules Building Failed (exit code: $ret)$ENDCOLOR"
		fi
	fi
}

function prepareModules() {
	echo -e "$BOLDGREEN[+] Preparing Modules$ENDCOLOR"
	if [ ! -f "$KDIR/$OUT_DIR/.config" ]; then
		echo -e "$BOLDRED[-] No .config found$ENDCOLOR"
	else
		echo -e "$BOLDGREEN[+] .config found$ENDCOLOR"
		make -s -C "$KDIR" O="$OUT_DIR" $BUILDER_ENV $BUILDER_ENV_2 modules_prepare -j"$(nproc)"
		ret=$?
		if [ $ret -eq 0 ]; then
			echo -e "$BOLDGREEN[+] Preparing Modules Succeed$ENDCOLOR"
		else
			echo -e "$BOLDRED[-] Preparing Modules Failed (exit code: $ret)$ENDCOLOR"
		fi
	fi
}

function copyModules() {
	echo -e "$BOLDGREEN[+] Coping Modules to $MODULES_OUT_DIR$ENDCOLOR"
	if [ ! -f "$KDIR/$OUT_DIR/.config" ]; then
		echo -e "$BOLDRED[-] No .config found$ENDCOLOR"
	else
		echo -e "$BOLDGREEN[+] .config found$ENDCOLOR"
		make -C "$KDIR" O="$OUT_DIR" INSTALL_MOD_PATH="$MODULES_OUT_DIR" $BUILDER_ENV $BUILDER_ENV_2 modules_install -j"$(nproc)"
		ret=$?
		if [ $ret -eq 0 ]; then
			echo -e "$BOLDGREEN[+] Coping Building Succeed$ENDCOLOR"
			echo -e "$BOLDGREEN[+] You can find the modules in $MODULES_OUT_DIR$ENDCOLOR"
		else
			echo -e "$BOLDRED[-] Coping Building Failed (exit code: $ret)$ENDCOLOR"
		fi
	fi
}

function cleanKernel() {
	echo -e "$BOLDGREEN[+] Cleaning$ENDCOLOR"
	if [[ ! -d "$KDIR/$MODULES_OUT_DIR" ]] then
		echo -e "$BOLDGREEN[+] Deleting $MODULES_OUT_DIR"
		rm -rf $MODULES_OUT_DIR
		ret=$?
		if [ $ret -eq 0 ]; then
			echo -e "$BOLDGREEN[+] Deleting Succeed$ENDCOLOR"
		else
			echo -e "$BOLDRED[-] Deleting Failed (exit code: $ret)$ENDCOLOR"
		fi
	fi
	make -s -C "$KDIR" O="$OUT_DIR" $BUILDER_ENV $BUILDER_ENV_2 clean -j"$(nproc)" && make -s -C "$KDIR" O="$OUT_DIR" $BUILDER_ENV $BUILDER_ENV_2 mrproper -j"$(nproc)"
	ret=$?
	if [ $ret -eq 0 ]; then
		echo -e "$BOLDGREEN[+] Cleaning Succeed$ENDCOLOR"
	else
		echo -e "$BOLDRED[-] Cleaning Failed (exit code: $ret)$ENDCOLOR"
	fi
}

function applyDefconfig() {
	echo -ne "$BOLDGREEN[+] Enter the defconfig's name: $ENDCOLOR"
	read config
	if [ ! -f "$KDIR/arch/$ARCH/configs/$config" ]; then
		echo -e "$BOLDRED[-] $config is not found$ENDCOLOR"
	else
		make -C "$KDIR" O="$OUT_DIR" $BUILDER_ENV $BUILDER_ENV_2 $config -j"$(nproc)"
		ret=$?
		if [ $ret -eq 0 ]; then
			echo -e "$BOLDGREEN[+] Config Applying Succeed$ENDCOLOR"
		else
			echo -e "$BOLDRED[-] Config Applying Failed (exit code: $ret)$ENDCOLOR"
		fi
	fi
}

function editConfig() {
	echo -e "$BOLDGREEN[+] Editing Config$ENDCOLOR"
	make -C "$KDIR" O="$OUT_DIR" $BUILDER_ENV $BUILDER_ENV_2 nconfig -j"$(nproc)"
}

function saveConfig() {
	echo -e "$BOLDGREEN[+] Saving current .config as new defconfig$ENDCOLOR"
	if [ ! -f "$KDIR/$OUT_DIR/.config" ]; then
		echo -e "$BOLDRED[!] .config is not found$ENDCOLOR"
	else
		echo -ne "$BOLDGREEN[!] Enter the new defconfig name: $ENDCOLOR"
		read newconfig
		if [ -f "$KDIR/arch/$ARCH/configs/$newconfig" ]; then
			echo -e "$BOLDRED[!] $newconfig is found"
			echo -ne "Do you want to overwrite it?$ENDCOLOR [y,N]: "
			read answer
			case "$answer" in
				Y|y)
					echo -e "$BOLDGREEN[+] Overwriting current .config as $newconfig$ENDCOLOR"
					cp "$KDIR/$OUT_DIR/.config" "$KDIR/arch/$ARCH/configs/$newconfig"
					ret=$?
					if [ $ret -eq 0 ]; then
						echo -e "$BOLDGREEN[+] Coping succeed$ENDCOLOR"
					else
						echo -e "$BOLDRED[-] Coping Failed (exit code: $ret)$ENDCOLOR"
					fi
					;;
				N|n|'')
					echo -e "$BOLDGREEN[!] Skipped Saving the new defconfig$ENDCOLOR"
					;;
			esac
		else
			echo -e "$BOLDGREEN[+] Saving current .config as $newconfig$ENDCOLOR"
			cp "$KDIR/$OUT_DIR/.config" "$KDIR/arch/$ARCH/configs/$newconfig"
			ret=$?
			if [ $ret -eq 0 ]; then
				echo -e "$BOLDGREEN[+] Coping succeed$ENDCOLOR"
			else
				echo -e "$BOLDRED[-] Coping Failed (exit code: $ret)$ENDCOLOR"
			fi
		fi
	fi
}

while true; do
	show_gui
	echo -ne "${BOLDCYAN}Enter the action [0-8/E/G]: $ENDCOLOR"
	read action

	case $action in
		1)
			cleanKernel
			applyDefconfig
			compileKernel
			;;
		2)
			compileKernel
			;;
		3)
			prepareModules
			compileModules
			;;
		4)
			prepareModules
			;;
		5)
			copyModules
			;;
		6)
			applyDefconfig
			;;
		7)
			editConfig
			;;
		8)
			saveConfig
			;;
		0)
			cleanKernel
			;;
		E|e)
			echo -e "$BOLDRED[!] Exiting!!$ENDCOLOR"
			break
			;;
		G|g)
			echo -e "$BOLDGREEN[+] Opening the creator's github page$ENDCOLOR"
			xdg-open https://github.com/karamdev1 > /dev/null 2>&1 &
			;;
		*)
			echo -e "$BOLDRED[!] Invalid Action!!$ENDCOLOR"
			;;
	esac
	echo -ne "${BOLDYELLOW}Press enter to continue$ENDCOLOR"
	read
done