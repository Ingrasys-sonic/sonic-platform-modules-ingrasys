#!/bin/bash

# Copyright (C) 2016 Ingrasys, Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

VERSION="1.0.0"
TRUE=200
FALSE=404
PORT_START=1
PORT_END=54

EXEC_FUNC=${1}
COLOR_LED=${2}
QSFP_PORT=${2}
ONOFF_LED=${3}
FAN_TRAY=${4}

############################################################
# Distributor ID: Debian
# Description:    Debian GNU/Linux 8.6 (jessie)
# Release:        8.6
# Codename:       jessie
# Linux debian 3.16.0-4-amd64 #1
# SMP Debian 3.16.36-1+deb8u1 (2016-09-03) x86_64 GNU/Linux
############################################################

# Color Definition
COLOR_TITLE="\e[1;32m"   ### Green ###
COLOR_WARNING="\e[1;33m" ### Yellow ###
COLOR_ERROR="\e[1;31m"   ### Red ###
COLOR_END="\e[0m"        ### END ###

NUM_IGB_DEVICE=0
NUM_I801_DEVICE=0
NUM_ISMT_DEVICE=$(( ${NUM_I801_DEVICE} + 1 ))
NUM_MUX1_CHAN0_DEVICE=$(( ${NUM_I801_DEVICE} + 2 ))
NUM_MUX1_CHAN1_DEVICE=$(( ${NUM_I801_DEVICE} + 3 ))
NUM_MUX1_CHAN2_DEVICE=$(( ${NUM_I801_DEVICE} + 4 ))
NUM_MUX1_CHAN3_DEVICE=$(( ${NUM_I801_DEVICE} + 5 ))
NUM_MUX1_CHAN4_DEVICE=$(( ${NUM_I801_DEVICE} + 6 ))
NUM_MUX1_CHAN5_DEVICE=$(( ${NUM_I801_DEVICE} + 7 ))
NUM_MUX1_CHAN6_DEVICE=$(( ${NUM_I801_DEVICE} + 8 ))
NUM_MUX1_CHAN7_DEVICE=$(( ${NUM_I801_DEVICE} + 9 ))
NUM_MUX2_CHAN0_DEVICE=$(( ${NUM_I801_DEVICE} + 10 ))
NUM_MUX2_CHAN1_DEVICE=$(( ${NUM_I801_DEVICE} + 11 ))
NUM_MUX2_CHAN2_DEVICE=$(( ${NUM_I801_DEVICE} + 12 ))
NUM_MUX2_CHAN3_DEVICE=$(( ${NUM_I801_DEVICE} + 13 ))
NUM_MUX2_CHAN4_DEVICE=$(( ${NUM_I801_DEVICE} + 14 ))
NUM_MUX2_CHAN5_DEVICE=$(( ${NUM_I801_DEVICE} + 15 ))
NUM_MUX2_CHAN6_DEVICE=$(( ${NUM_I801_DEVICE} + 16 ))
NUM_MUX2_CHAN7_DEVICE=$(( ${NUM_I801_DEVICE} + 17 ))
NUM_MUX3_CHAN0_DEVICE=$(( ${NUM_I801_DEVICE} + 18 ))
NUM_MUX4_CHAN0_DEVICE=$(( ${NUM_I801_DEVICE} + 26 ))
NUM_MUX5_CHAN0_DEVICE=$(( ${NUM_I801_DEVICE} + 34 ))
NUM_MUX6_CHAN0_DEVICE=$(( ${NUM_I801_DEVICE} + 42 ))
NUM_MUX7_CHAN0_DEVICE=$(( ${NUM_I801_DEVICE} + 50 ))
NUM_MUX8_CHAN0_DEVICE=$(( ${NUM_I801_DEVICE} + 58 ))
NUM_MUX9_CHAN0_DEVICE=$(( ${NUM_I801_DEVICE} + 66 ))

PATH_SYS_I2C_DEVICES="/sys/bus/i2c/devices"
PATH_HWMON_ROOT_DEVICES="/sys/class/hwmon"
PATH_HWMON_W83795_DEVICE="${PATH_HWMON_ROOT_DEVICES}/hwmon2"
PATH_I801_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_I801_DEVICE}"
PATH_ISMT_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_ISMT_DEVICE}"
PATH_MUX_CHAN0_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN0_DEVICE}"
PATH_MUX_CHAN1_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN1_DEVICE}"
PATH_MUX_CHAN2_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN2_DEVICE}"
PATH_MUX_CHAN3_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN3_DEVICE}"
PATH_MUX_CHAN4_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN4_DEVICE}"
PATH_MUX_CHAN5_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN5_DEVICE}"
PATH_MUX_CHAN6_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN6_DEVICE}"
PATH_MUX_CHAN7_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN7_DEVICE}"

#SFP/QSFP EEPROM i2c bus index
SFP_EEPROM_BUS_IDX=0

#Power Supply Status
PSU_DC_ON=1
PSU_DC_OFF=0
PSU_EXIST=1
PSU_NOT_EXIST=0

# Help usage function
function _help {
    echo "========================================================="
    echo "# Description: Help Function"
    echo "========================================================="
    echo "----------------------------------------------------"
    echo "EX       : ${0} help"
    echo "         : ${0} i2c_init"
    echo "         : ${0} i2c_deinit"
    echo "         : ${0} i2c_temp_init"
    echo "         : ${0} i2c_fan_init"
    echo "         : ${0} i2c_volmon_init"
    echo "         : ${0} i2c_io_exp_init"
    echo "         : ${0} i2c_gpio_init"
    echo "         : ${0} i2c_gpio_deinit"
    echo "         : ${0} i2c_led_test"
    echo "         : ${0} i2c_psu_eeprom_get"
    echo "         : ${0} i2c_mb_eeprom_get"
    echo "         : ${0} i2c_qsfp_eeprom_get [1-54]"
    echo "         : ${0} i2c_board_type_get"
    echo "         : ${0} i2c_psu_status"
    echo "         : ${0} i2c_led_psu_status_set"
    echo "         : ${0} i2c_led_fan_status_set"
    echo "         : ${0} i2c_led_fan_tray_status_set"
    echo "         : ${0} i2c_cpld_version"
    echo "         : ${0} i2c_front_temp"
    echo "         : ${0} i2c_rear_temp"
    echo "         : ${0} i2c_test_all"
    echo "         : ${0} i2c_sys_led green|amber on|off"
    echo "         : ${0} i2c_fan_led green|amber on|off"
    echo "         : ${0} i2c_psu1_led green|amber on|off"
    echo "         : ${0} i2c_psu2_led green|amber on|off"
    echo "         : ${0} i2c_fan_tray_led green|amber on|off [1-4]"
    echo "----------------------------------------------------"
}

#Pause function
function _pause {
    read -p "$*"
}

#Retry command function
function _retry {
    for i in {1..5};
    do
       eval "${*}" && break || echo "retry"; sleep 1;
    done
}


#I2C Init
function _i2c_init {
    echo "========================================================="
    echo "# Description: I2C Init"
    echo "========================================================="

    rmmod i2c_ismt
    rmmod i2c_i801
    modprobe i2c_i801
    modprobe i2c_ismt
    modprobe i2c_dev
    modprobe i2c_mux_pca954x force_deselect_on_exit=1

    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9548 0x70' > ${PATH_ISMT_DEVICE}/new_device"
    else
        echo "pca9548 0x70 already init."
    fi
    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX2_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9548 0x72' > ${PATH_ISMT_DEVICE}/new_device"
    else
        echo "pca9548 0x72 already init."
    fi
    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX3_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9548 0x71' > ${PATH_MUX_CHAN0_DEVICE}/new_device"
    else
        echo "pca9548 0x71 already init."
    fi
    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX4_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9548 0x71' > ${PATH_MUX_CHAN1_DEVICE}/new_device"
    else
        echo "pca9548 0x71 already init."
    fi
    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX5_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9548 0x71' > ${PATH_MUX_CHAN2_DEVICE}/new_device"
    else
        echo "pca9548 0x71 already init."
    fi
    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX6_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9548 0x71' > ${PATH_MUX_CHAN3_DEVICE}/new_device"
    else
        echo "pca9548 0x71 already init."
    fi
    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX7_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9548 0x71' > ${PATH_MUX_CHAN4_DEVICE}/new_device"
    else
        echo "pca9548 0x71 already init."
    fi
    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX8_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9548 0x71' > ${PATH_MUX_CHAN5_DEVICE}/new_device"
    else
        echo "pca9548 0x71 already init."
    fi
    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX9_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9548 0x71' > ${PATH_MUX_CHAN6_DEVICE}/new_device"
    else
        echo "pca9548 0x71 already init."
    fi

    #Init CPLD LED_CLR Register (Front Port LED)
    i2cset -y ${NUM_I801_DEVICE} 0x33 0x34 0x10

    rmmod coretemp
    rmmod jc42
    rmmod w83795
    _i2c_temp_init
    _i2c_volmon_init
    _i2c_hwmon_init
    modprobe coretemp
    modprobe jc42
    modprobe w83795
    modprobe sff_8436_eeprom
    modprobe eeprom
    modprobe eeprom_mb
    _i2c_fan_init
    _i2c_io_exp_init
    _i2c_gpio_init
    _i2c_led_psu_status_set
    _i2c_led_fan_status_set
    COLOR_LED="green"
    ONOFF_LED="on"
    echo "${COLOR_LED} ${ONOFF_LED}"
    _i2c_sys_led
    COLOR_LED="amber"
    ONOFF_LED="off"
    echo "${COLOR_LED} ${ONOFF_LED}"
    _i2c_sys_led
    echo "Mount Main Board EEPROM"
    echo "mb_eeprom 0x54" > /sys/bus/i2c/devices/i2c-17/new_device
    for (( i=$PORT_START; i<=$PORT_END; i++ ))
    do
        _i2c_mount_sfp_eeprom $i
    done
}

#I2C Deinit
function _i2c_deinit {
    _i2c_gpio_deinit
    for mod in coretemp jc42 w83795 eeprom_mb gpio-pca953x i2c_mux_pca954x i2c_ismt i2c_i801;
    do
        [ "$(lsmod | grep "^$mod ")" != "" ] && rmmod $mod
    done
}

#Temperature sensor Init
function _i2c_temp_init {
    i2cset -y -r ${NUM_I801_DEVICE} 0x2F 0x00 0x80
    i2cset -y -r ${NUM_I801_DEVICE} 0x2F 0x05 0x7F
    i2cset -y -r ${NUM_I801_DEVICE} 0x2F 0x04 0x0A
    echo "TEMP INIT Done"
}

#FAN Init
function _i2c_fan_init {
    echo -n "FAN INIT..."
    if [ -e "${PATH_HWMON_W83795_DEVICE}" ]; then
        echo 120 > ${PATH_HWMON_W83795_DEVICE}/device/pwm1
        echo 120 > ${PATH_HWMON_W83795_DEVICE}/device/pwm2
        echo "SUCCESS"
    else
        echo "FAIL"
    fi

}

#VOLMON Init
function _i2c_volmon_init {
    echo -n "VOLMON INIT..."
    i2cset -y -r ${NUM_I801_DEVICE} 0x2F 0x00 0x80
    i2cset -y -r ${NUM_I801_DEVICE} 0x2F 0x02 0xFF
    i2cset -y -r ${NUM_I801_DEVICE} 0x2F 0x03 0x50
    i2cset -y -r ${NUM_I801_DEVICE} 0x2F 0x04 0x0A
    echo "Done"
}

#HWMON Init
function _i2c_hwmon_init {
    echo -n "HWMON INIT..."
    i2cset -y ${NUM_I801_DEVICE} 0x2F 0x00 0x80
    i2cset -y ${NUM_I801_DEVICE} 0x2F 0x06 0xFF
    echo "Done"
}

#IO Expander Init
function _i2c_io_exp_init {
    echo "========================================================="
    echo "# Description: I2C IO Expender Init"
    echo "========================================================="
    #SMBUS0 IO_EXPENDER
    i2cset -y -r ${NUM_I801_DEVICE} 0x27 4 0x00
    i2cset -y -r ${NUM_I801_DEVICE} 0x27 5 0x00
    i2cset -y -r ${NUM_I801_DEVICE} 0x27 6 0xFF
    i2cset -y -r ${NUM_I801_DEVICE} 0x27 7 0xFF

    #SMBUS1
    #SFP+ ABS
    i2cset -y -r ${NUM_MUX2_CHAN0_DEVICE} 0x20 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN0_DEVICE} 0x20 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN0_DEVICE} 0x21 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN0_DEVICE} 0x21 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN0_DEVICE} 0x22 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN0_DEVICE} 0x22 5 0x00

    i2cset -y -r ${NUM_MUX2_CHAN0_DEVICE} 0x20 6 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN0_DEVICE} 0x20 7 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN0_DEVICE} 0x21 6 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN0_DEVICE} 0x21 7 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN0_DEVICE} 0x22 6 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN0_DEVICE} 0x22 7 0xFF

    #QSFP/ZQSFP ABS
    i2cset -y -r ${NUM_MUX2_CHAN0_DEVICE} 0x23 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN0_DEVICE} 0x23 6 0xFF

    #QSFP/ZQSFP INT
    i2cset -y -r ${NUM_MUX2_CHAN0_DEVICE} 0x23 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN0_DEVICE} 0x23 7 0xFF

    #SFP+ RX_LOS
    i2cset -y -r ${NUM_MUX2_CHAN1_DEVICE} 0x20 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN1_DEVICE} 0x20 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN1_DEVICE} 0x21 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN1_DEVICE} 0x21 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN1_DEVICE} 0x22 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN1_DEVICE} 0x22 5 0x00

    i2cset -y -r ${NUM_MUX2_CHAN1_DEVICE} 0x20 6 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN1_DEVICE} 0x20 7 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN1_DEVICE} 0x21 6 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN1_DEVICE} 0x21 7 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN1_DEVICE} 0x22 6 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN1_DEVICE} 0x22 7 0xFF

    #SFP+ TX_FAULT
    i2cset -y -r ${NUM_MUX2_CHAN2_DEVICE} 0x20 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN2_DEVICE} 0x20 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN2_DEVICE} 0x21 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN2_DEVICE} 0x21 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN2_DEVICE} 0x22 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN2_DEVICE} 0x22 5 0x00

    i2cset -y -r ${NUM_MUX2_CHAN2_DEVICE} 0x20 6 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN2_DEVICE} 0x20 7 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN2_DEVICE} 0x21 6 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN2_DEVICE} 0x21 7 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN2_DEVICE} 0x22 6 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN2_DEVICE} 0x22 7 0xFF

    #SFP+ TX_RS
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x20 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x20 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x21 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x21 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x22 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x22 5 0x00

    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x20 2 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x20 3 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x21 2 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x21 3 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x22 2 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x22 3 0xFF

    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x20 6 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x20 7 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x21 6 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x21 7 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x22 6 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x22 7 0xFF

    #QSFP/zQSFP LPMODE
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x23 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x23 2 0x00
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x23 6 0x00

    #QSFP/zQSFP MODSEL
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x23 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x23 3 0x00
    i2cset -y -r ${NUM_MUX2_CHAN3_DEVICE} 0x23 7 0x00

    #SFP+ RX_RS
    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x20 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x20 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x21 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x21 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x22 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x22 5 0x00

    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x20 2 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x20 3 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x21 2 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x21 3 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x22 2 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x22 3 0xFF

    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x20 6 0x00
    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x20 7 0x00
    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x21 6 0x00
    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x21 7 0x00
    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x22 6 0x00
    i2cset -y -r ${NUM_MUX2_CHAN4_DEVICE} 0x22 7 0x00

    #SFP+ TX_DIS
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x20 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x20 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x21 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x21 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x22 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x22 5 0x00

    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x20 2 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x20 3 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x21 2 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x21 3 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x22 2 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x22 3 0x00

    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x20 6 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x20 7 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x21 6 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x21 7 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x22 6 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x22 7 0x00

    #QSFP/zQSFP RST
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x23 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x23 2 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x23 6 0x00

    #SFP/QSFP/zQSFP I/O
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x24 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x24 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x24 6 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN5_DEVICE} 0x24 7 0xFF

    #ZQSFP/SFP+/E-Card General
    i2cset -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x21 4 0x00
    i2cset -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x21 5 0x00
    i2cset -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x21 2 0x00
    i2cset -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x21 3 0x00
    i2cset -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x21 6 0xF4
    i2cset -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x21 7 0xF4

    #LED board after PVT (S8900_IO_EXP_LED_ID)
    echo "Init LED IO Expender"
    i2cset -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 4 0x00
    i2cset -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 5 0x00
    i2cset -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 6 0x00
    i2cset -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 7 0x00

    #PSU I/O (S8900_IO_EXP_PSU_ID)
    echo "Init PSU IO Expender"
    i2cset -y -r ${NUM_MUX2_CHAN6_DEVICE} 0x20 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN6_DEVICE} 0x20 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN6_DEVICE} 0x20 2 0x00
    i2cset -y -r ${NUM_MUX2_CHAN6_DEVICE} 0x20 3 0x00
    i2cset -y -r ${NUM_MUX2_CHAN6_DEVICE} 0x20 6 0xFF
    i2cset -y -r ${NUM_MUX2_CHAN6_DEVICE} 0x20 7 0xFF

    #FAN I/O (S8900_IO_EXP_FAN_ID)
    echo "Init FAN IO Expender"
    i2cset -y -r ${NUM_MUX2_CHAN7_DEVICE} 0x20 4 0x00
    i2cset -y -r ${NUM_MUX2_CHAN7_DEVICE} 0x20 5 0x00
    i2cset -y -r ${NUM_MUX2_CHAN7_DEVICE} 0x20 2 0x11
    i2cset -y -r ${NUM_MUX2_CHAN7_DEVICE} 0x20 3 0x11
    i2cset -y -r ${NUM_MUX2_CHAN7_DEVICE} 0x20 6 0xCC
    i2cset -y -r ${NUM_MUX2_CHAN7_DEVICE} 0x20 7 0xCC
}

function _get_sfp_eeprom_bus_idx {
    case $1 in
        1|2|3|4|5|6|7|8)
            SFP_EEPROM_BUS_IDX=$(( (${NUM_MUX3_CHAN0_DEVICE} + $1 - 1) ))
        ;;
        9|10|11|12|13|14|15|16)
            SFP_EEPROM_BUS_IDX=$(( (${NUM_MUX4_CHAN0_DEVICE} + $1 - 9) ))
        ;;
        17|18|19|20|21|22|23|24)
            SFP_EEPROM_BUS_IDX=$(( (${NUM_MUX5_CHAN0_DEVICE} + $1 - 17) ))
        ;;
        25|26|27|28|29|30|31|32)
            SFP_EEPROM_BUS_IDX=$(( (${NUM_MUX6_CHAN0_DEVICE} + $1 - 25) ))
        ;;
        33|34|35|36|37|38|39|40)
            SFP_EEPROM_BUS_IDX=$(( (${NUM_MUX7_CHAN0_DEVICE} + $1 - 33) ))
        ;;
        41|42|43|44|45|46|47|48)
            SFP_EEPROM_BUS_IDX=$(( (${NUM_MUX8_CHAN0_DEVICE} + $1 - 41) ))
        ;;
        49|50|51|52|53|54)
            SFP_EEPROM_BUS_IDX=$(( (${NUM_MUX9_CHAN0_DEVICE} + $1 - 49) ))
        ;;
        *)
            SFP_EEPROM_BUS_IDX=-1
        ;;
    esac
}

#Mount SFP/QSFP EEPROM
function _i2c_mount_sfp_eeprom {
    _get_sfp_eeprom_bus_idx $1
    eeprombus=${SFP_EEPROM_BUS_IDX}
    eepromAddr=0x50
    echo "sff8436 $eepromAddr" > /sys/bus/i2c/devices/i2c-$eeprombus/new_device
    echo "Mount Port $1 EEPROM"
}

#Unmount SFP/QSFP EEPROM
function _i2c_unmount_sfp_eeprom {
    _get_sfp_eeprom_bus_idx $1
    eeprombus=${SFP_EEPROM_BUS_IDX}
    eepromAddr=0x50
    echo "$eepromAddr" > /sys/bus/i2c/devices/i2c-$eeprombus/new_device
    echo "Unmount Port $1 EEPROM"
}

#GPIO Init
function _i2c_gpio_init {

    #QSFP/ZQSFP ABS+INT
    echo "pca9535 0x23" > /sys/bus/i2c/devices/i2c-${NUM_MUX2_CHAN0_DEVICE}/new_device

    _retry "echo 240 > /sys/class/gpio/export"
    echo 241 > /sys/class/gpio/export
    echo 242 > /sys/class/gpio/export
    echo 243 > /sys/class/gpio/export
    echo 244 > /sys/class/gpio/export
    echo 245 > /sys/class/gpio/export
    echo 246 > /sys/class/gpio/export
    echo 247 > /sys/class/gpio/export
    echo 248 > /sys/class/gpio/export
    echo 249 > /sys/class/gpio/export
    echo 250 > /sys/class/gpio/export
    echo 251 > /sys/class/gpio/export
    echo 252 > /sys/class/gpio/export
    echo 253 > /sys/class/gpio/export
    echo 254 > /sys/class/gpio/export
    echo 255 > /sys/class/gpio/export

    echo 1 > /sys/class/gpio/gpio241/active_low #QSFP49 ABS
    echo 1 > /sys/class/gpio/gpio240/active_low #QSFP48 ABS
    echo 1 > /sys/class/gpio/gpio243/active_low #QSFP51 ABS
    echo 1 > /sys/class/gpio/gpio242/active_low #QSFP50 ABS
    echo 1 > /sys/class/gpio/gpio245/active_low #QSFP53 ABS
    echo 1 > /sys/class/gpio/gpio244/active_low #QSFP52 ABS
    echo 1 > /sys/class/gpio/gpio247/active_low #NA
    echo 1 > /sys/class/gpio/gpio246/active_low #NA
    echo 1 > /sys/class/gpio/gpio249/active_low #QSFP49 INT
    echo 1 > /sys/class/gpio/gpio248/active_low #QSFP48 INT
    echo 1 > /sys/class/gpio/gpio251/active_low #QSFP51 INT
    echo 1 > /sys/class/gpio/gpio250/active_low #QSFP50 INT
    echo 1 > /sys/class/gpio/gpio253/active_low #QSFP53 INT
    echo 1 > /sys/class/gpio/gpio252/active_low #QSFP52 INT
    echo 1 > /sys/class/gpio/gpio255/active_low #NA
    echo 1 > /sys/class/gpio/gpio254/active_low #NA

    #QSFP/zQSFP LPMODE+MODSEL
    echo "pca9535 0x23" > /sys/bus/i2c/devices/i2c-${NUM_MUX2_CHAN3_DEVICE}/new_device
    echo 224 > /sys/class/gpio/export  #QSFP0 LPMODE
    echo 225 > /sys/class/gpio/export  #QSFP1 LPMODE
    echo 226 > /sys/class/gpio/export  #QSFP2 LPMODE
    echo 227 > /sys/class/gpio/export  #QSFP3 LPMODE
    echo 228 > /sys/class/gpio/export  #QSFP4 LPMODE
    echo 229 > /sys/class/gpio/export  #QSFP5 LPMODE
    echo 230 > /sys/class/gpio/export  #NA
    echo 231 > /sys/class/gpio/export  #NA
    echo 232 > /sys/class/gpio/export  #QSFP0 MODSEL
    echo 233 > /sys/class/gpio/export  #QSFP1 MODSEL
    echo 234 > /sys/class/gpio/export  #QSFP2 MODSEL
    echo 235 > /sys/class/gpio/export  #QSFP3 MODSEL
    echo 236 > /sys/class/gpio/export  #QSFP4 MODSEL
    echo 237 > /sys/class/gpio/export  #QSFP5 MODSEL
    echo 238 > /sys/class/gpio/export  #NA
    echo 239 > /sys/class/gpio/export  #NA
    echo out > /sys/class/gpio/gpio224/direction
    echo out > /sys/class/gpio/gpio225/direction
    echo out > /sys/class/gpio/gpio226/direction
    echo out > /sys/class/gpio/gpio227/direction
    echo out > /sys/class/gpio/gpio228/direction
    echo out > /sys/class/gpio/gpio229/direction
    echo out > /sys/class/gpio/gpio230/direction
    echo out > /sys/class/gpio/gpio231/direction
    echo out > /sys/class/gpio/gpio232/direction
    echo out > /sys/class/gpio/gpio233/direction
    echo out > /sys/class/gpio/gpio234/direction
    echo out > /sys/class/gpio/gpio235/direction
    echo out > /sys/class/gpio/gpio236/direction
    echo out > /sys/class/gpio/gpio237/direction
    echo out > /sys/class/gpio/gpio238/direction
    echo out > /sys/class/gpio/gpio239/direction

}

#GPIO DeInit
function _i2c_gpio_deinit {
    echo "0x23" > /sys/bus/i2c/devices/i2c-${NUM_MUX2_CHAN0_DEVICE}/delete_device
    echo "0x23" > /sys/bus/i2c/devices/i2c-${NUM_MUX2_CHAN3_DEVICE}/delete_device
}

#Set FAN Tray LED
function _i2c_led_fan_tray_status_set {
    echo "FAN Tray Status Setup"
    #FAN Status get
    FAN1_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan1_alarm`
    FAN2_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan2_alarm`
    FAN3_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan3_alarm`
    FAN4_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan4_alarm`
    FAN5_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan5_alarm`
    FAN6_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan6_alarm`
    FAN7_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan7_alarm`
    FAN8_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan8_alarm`

    if [ "${FAN1_ALARM}" == "0" ] && [ "${FAN2_ALARM}" == "0" ]; then
	FAN_TRAY=1
        COLOR_LED="green"
        ONOFF_LED="on"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
        COLOR_LED="amber"
        ONOFF_LED="off"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
    else
	FAN_TRAY=1
        COLOR_LED="green"
        ONOFF_LED="off"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
        COLOR_LED="amber"
        ONOFF_LED="on"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
    fi

    if [ "${FAN3_ALARM}" == "0" ] && [ "${FAN4_ALARM}" == "0" ]; then
	FAN_TRAY=2
        COLOR_LED="green"
        ONOFF_LED="on"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
        COLOR_LED="amber"
        ONOFF_LED="off"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
    else
	FAN_TRAY=2
        COLOR_LED="green"
        ONOFF_LED="off"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
        COLOR_LED="amber"
        ONOFF_LED="on"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
    fi

    if [ "${FAN5_ALARM}" == "0" ] && [ "${FAN6_ALARM}" == "0" ]; then
	FAN_TRAY=3
        COLOR_LED="green"
        ONOFF_LED="on"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
        COLOR_LED="amber"
        ONOFF_LED="off"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
    else
	FAN_TRAY=3
        COLOR_LED="green"
        ONOFF_LED="off"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
        COLOR_LED="amber"
        ONOFF_LED="on"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
    fi

    if [ "${FAN7_ALARM}" == "0" ] && [ "${FAN8_ALARM}" == "0" ]; then
	FAN_TRAY=4
        COLOR_LED="green"
        ONOFF_LED="on"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
        COLOR_LED="amber"
        ONOFF_LED="off"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
    else
	FAN_TRAY=4
        COLOR_LED="green"
        ONOFF_LED="off"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
        COLOR_LED="amber"
        ONOFF_LED="on"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
    fi
}

#Set FAN LED
function _i2c_led_fan_status_set {
    echo "FAN Status Setup"
    #PSU Status set
    FAN1_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan1_alarm`
    FAN2_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan2_alarm`
    FAN3_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan3_alarm`
    FAN4_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan4_alarm`
    FAN5_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan5_alarm`
    FAN6_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan6_alarm`
    FAN7_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan7_alarm`
    FAN8_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan8_alarm`

    if [ "${FAN1_ALARM}" == "0" ] && [ "${FAN2_ALARM}" == "0" ] \
       && [ "${FAN3_ALARM}" == "0" ] && [ "${FAN4_ALARM}" == "0" ] \
       && [ "${FAN5_ALARM}" == "0" ] && [ "${FAN6_ALARM}" == "0" ] \
       && [ "${FAN7_ALARM}" == "0" ] && [ "${FAN8_ALARM}" == "0" ]; then
        COLOR_LED="green"
        ONOFF_LED="on"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_led
        COLOR_LED="amber"
        ONOFF_LED="off"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_led
    else
        COLOR_LED="green"
        ONOFF_LED="off"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_led
        COLOR_LED="amber"
        ONOFF_LED="on"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_fan_led
    fi
}

#Set Power Supply LED
function _i2c_led_psu_status_set {
    echo "PSU LED Status Setup"

    #PSU Status set
    _i2c_psu_status

    #PSU1 Status
    if [ "${psu1Exist}" == ${PSU_EXIST} ]; then
        if [ "${psu1PwGood}" == ${PSU_DC_ON} ]; then
            COLOR_LED="green"
            ONOFF_LED="on"
            echo "${COLOR_LED} ${ONOFF_LED}"
            _i2c_psu1_led
            COLOR_LED="amber"
            ONOFF_LED="off"
            echo "${COLOR_LED} ${ONOFF_LED}"
            _i2c_psu1_led
        else
            COLOR_LED="green"
            ONOFF_LED="off"
            echo "${COLOR_LED} ${ONOFF_LED}"
            _i2c_psu1_led
            COLOR_LED="amber"
            ONOFF_LED="on"
            echo "${COLOR_LED} ${ONOFF_LED}"
            _i2c_psu1_led
        fi
    else
        COLOR_LED="green"
        ONOFF_LED="off"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_psu1_led
        COLOR_LED="amber"
        ONOFF_LED="on"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_psu1_led
    fi

    #PSU2 Status
    if [ "${psu2Exist}" == ${PSU_EXIST} ]; then
        if [ "${psu2PwGood}" == ${PSU_DC_ON} ]; then
            COLOR_LED="green"
            ONOFF_LED="on"
            echo "${COLOR_LED} ${ONOFF_LED}"
            _i2c_psu2_led
            COLOR_LED="amber"
            ONOFF_LED="off"
            echo "${COLOR_LED} ${ONOFF_LED}"
            _i2c_psu2_led
        else
            COLOR_LED="green"
            ONOFF_LED="off"
            echo "${COLOR_LED} ${ONOFF_LED}"
            _i2c_psu2_led
            COLOR_LED="amber"
            ONOFF_LED="on"
            echo "${COLOR_LED} ${ONOFF_LED}"
            _i2c_psu2_led
        fi
    else
        COLOR_LED="green"
        ONOFF_LED="off"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_psu2_led
        COLOR_LED="amber"
        ONOFF_LED="on"
        echo "${COLOR_LED} ${ONOFF_LED}"
        _i2c_psu2_led
    fi
}

#LED Test
function _i2c_led_test {
    echo "========================================================="
    echo "# Description: I2C LED TEST..."
    echo "========================================================="
    #sys led (green)
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0x7F
    _pause 'Check SYS LED green light and Press [Enter] key to continue...'
    #sys led (amber)
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xBF
    _pause 'Check SYS LED amber light and Press [Enter] key to continue...'

    #FAN led (green)
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xF7
    _pause 'Check FAN LED green light and Press [Enter] key to continue...'
    #FAN led (amber)
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFB
    _pause 'Check FAN LED amber light and Press [Enter] key to continue...'

    #PSU2 led (green)
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xDF
    _pause 'Check PSU2 LED green light and Press [Enter] key to continue...'
    #PSU2 led (amber)
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xEF
    _pause 'Check PSU2 LED amber light and Press [Enter] key to continue...'

    #PSU1 led (green)
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFD
    _pause 'Check PSU1 LED green light and Press [Enter] key to continue...'
    #PSU1 led (amber)
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFE
    _pause 'Check PSU1 LED amber light and Press [Enter] key to continue...'

    #Turn OFF All LED
    i2cset -y ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    _pause 'Check turn off all LEDs and Press [Enter] key to continue...'
    echo "done..."
}

#Set QSFP Port variable
function _qsfp_port_i2c_var_set {
    local port=$1
    case ${port} in
        1|2|3|4|5|6|7|8)
            i2cbus=${NUM_MUX2_CHAN0_DEVICE}
            regAddr=0x20
            dataAddr=0
        ;;
        9|10|11|12|13|14|15|16)
            i2cbus=${NUM_MUX2_CHAN0_DEVICE}
            regAddr=0x20
            dataAddr=1
        ;;
        17|18|19|20|21|22|23|24)
            i2cbus=${NUM_MUX2_CHAN0_DEVICE}
            regAddr=0x21
            dataAddr=0
        ;;
        25|26|27|28|29|30|31|32)
            i2cbus=${NUM_MUX2_CHAN0_DEVICE}
            regAddr=0x21
            dataAddr=1
        ;;
        33|34|35|36|37|38|39|40)
            i2cbus=${NUM_MUX2_CHAN0_DEVICE}
            regAddr=0x22
            dataAddr=0
        ;;
        41|42|43|44|45|46|47|48)
            i2cbus=${NUM_MUX2_CHAN0_DEVICE}
            regAddr=0x22
            dataAddr=1
        ;;
        49|50|51|52|53|54)
            i2cbus=${NUM_MUX2_CHAN0_DEVICE}
            regAddr=0x23
            dataAddr=0
            gpioBase=$((240 - 48))
        ;;
        *)
            echo "Please input 1~54"
            exit ${FALSE}
        ;;
    esac
}

#Get QSFP EEPROM Information
function _i2c_qsfp_eeprom_get {

    _qsfp_port_i2c_var_set ${QSFP_PORT}

    if [ ${QSFP_PORT} -lt 49 ] && [ ${QSFP_PORT} -gt 0 ]; then
        regData=`i2cget -y $i2cbus $regAddr $dataAddr`
        presentChan=$(( (${QSFP_PORT} - 1) % 8 ))

        #status: 0 -> Down, 1 -> Up
        status=$(( $(($regData & ( 1 << $presentChan)))  != 0 ? 0 : 1 ))
        echo $status

        if [ $status = 0 ]; then
            exit
        fi

        _get_sfp_eeprom_bus_idx ${QSFP_PORT}
        eeprombus=${SFP_EEPROM_BUS_IDX}
        eepromAddr=0x50
        cat ${PATH_SYS_I2C_DEVICES}/$eeprombus-$(printf "%04x" $eepromAddr)/eeprom | hexdump -C
    elif [ ${QSFP_PORT} -ge 49 ] && [ ${QSFP_PORT} -le 54 ]; then
        #status: 0 -> Down, 1 -> Up
        status=`cat /sys/class/gpio/gpio$(( $(($gpioBase + (${QSFP_PORT} - 1))) ))/value`
        echo $status

        if [ $status = 0 ]; then
            exit
        fi
        _get_sfp_eeprom_bus_idx ${QSFP_PORT}
        eeprombus=${SFP_EEPROM_BUS_IDX}
        eepromAddr=0x50
        cat ${PATH_SYS_I2C_DEVICES}/$eeprombus-$(printf "%04x" $eepromAddr)/eeprom | hexdump -C
    else
        echo "Invalid Parameters, Exit!!!"
        _help
        exit ${FALSE}
    fi

}

#Get PSU EEPROM Information
function _i2c_psu_eeprom_get {
    echo "========================================================="
    echo "# Description: I2C PSU EEPROM Get..."
    echo "========================================================="

    ## modprobe eeprom
    modprobe eeprom
    ## PUS(0) EEPROM
    echo "eeprom 0x50" > ${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX2_CHAN6_DEVICE}/new_device
    dd if=${PATH_SYS_I2C_DEVICES}/${NUM_MUX2_CHAN6_DEVICE}-0050/eeprom  of=psu0.rom
    echo "0x50" > ${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX2_CHAN6_DEVICE}/delete_device
    cat psu0.rom | hexdump -C

    ## PUS(1) EEPROM
    echo "eeprom 0x50" > ${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX2_CHAN7_DEVICE}/new_device
    dd if=${PATH_SYS_I2C_DEVICES}/${NUM_MUX2_CHAN7_DEVICE}-0050/eeprom  of=psu1.rom
    echo "0x50" > ${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX2_CHAN7_DEVICE}/delete_device
    cat psu1.rom | hexdump -C

    echo "done..."
}

#Get MotherBoard EEPROM Information
function _i2c_mb_eeprom_get {
    echo "========================================================="
    echo "# Description: I2C MB EEPROM Get..."
    echo "========================================================="

    ## modprobe eeprom
    modprobe eeprom_mb

    ## MB EEPROM
    cat ${PATH_SYS_I2C_DEVICES}/${NUM_MUX2_CHAN7_DEVICE}-0054/eeprom | hexdump -C
    echo "done..."
}

#Set System Status LED
function _i2c_sys_led {
    if [ "${COLOR_LED}" == "green" ] && [ "${ONOFF_LED}" == "on" ]; then
        i2cset -m 0x80 -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0x00
    elif [ "${COLOR_LED}" == "green" ] && [ "${ONOFF_LED}" == "off" ]; then
        i2cset -m 0x80 -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    elif [ "${COLOR_LED}" == "amber" ] && [ "${ONOFF_LED}" == "on" ]; then
        i2cset -m 0x40 -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0x00
    elif [ "${COLOR_LED}" == "amber" ] && [ "${ONOFF_LED}" == "off" ]; then
        i2cset -m 0x40 -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    else
        echo "Invalid Parameters, Exit!!!"
        _help
        exit ${FALSE}
    fi

    echo "done..."
}

#Set PSU2 LED
function _i2c_psu2_led {
    if [ "${COLOR_LED}" == "green" ] && [ "${ONOFF_LED}" == "on" ]; then
        i2cset -m 0x20 -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0x00
    elif [ "${COLOR_LED}" == "green" ] && [ "${ONOFF_LED}" == "off" ]; then
        i2cset -m 0x20 -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    elif [ "${COLOR_LED}" == "amber" ] && [ "${ONOFF_LED}" == "on" ]; then
        i2cset -m 0x10 -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0x00
    elif [ "${COLOR_LED}" == "amber" ] && [ "${ONOFF_LED}" == "off" ]; then
        i2cset -m 0x10 -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    else
        echo "Invalid Parameters, Exit!!!"
        _help
        exit ${FALSE}
    fi

    echo "done..."
}

#Set FAN Tray LED
function _i2c_fan_tray_led {
    case ${FAN_TRAY} in
        1)
            i2cAddr=0x20
            ioPort=2
            if [ "${COLOR_LED}" == "green" ]; then
                mask=0x01
            elif [ "${COLOR_LED}" == "amber" ]; then
                mask=0x02
            fi
            ;;
        2)
            i2cAddr=0x20
            ioPort=2
            if [ "${COLOR_LED}" == "green" ]; then
                mask=0x10
            elif [ "${COLOR_LED}" == "amber" ]; then
                mask=0x20
            fi
            ;;
        3)
            i2cAddr=0x20
            ioPort=3
            if [ "${COLOR_LED}" == "green" ]; then
                mask=0x01
            elif [ "${COLOR_LED}" == "amber" ]; then
                mask=0x02
            fi
            ;;
        4)
            i2cAddr=0x20
            ioPort=3
            if [ "${COLOR_LED}" == "green" ]; then
                mask=0x10
            elif [ "${COLOR_LED}" == "amber" ]; then
                mask=0x20
            fi
            ;;
        *)
            echo "Please input 1~4"
            exit
        ;;
    esac

    if [ "${COLOR_LED}" == "green" ] && [ "${ONOFF_LED}" == "on" ]; then
        i2cset -m $mask -y -r ${NUM_MUX2_CHAN7_DEVICE} $i2cAddr $ioPort 0x33
    elif [ "${COLOR_LED}" == "green" ] && [ "${ONOFF_LED}" == "off" ]; then
        i2cset -m $mask -y -r ${NUM_MUX2_CHAN7_DEVICE} $i2cAddr $ioPort 0x00
    elif [ "${COLOR_LED}" == "amber" ] && [ "${ONOFF_LED}" == "on" ]; then
        i2cset -m $mask -y -r ${NUM_MUX2_CHAN7_DEVICE} $i2cAddr $ioPort 0x33
    elif [ "${COLOR_LED}" == "amber" ] && [ "${ONOFF_LED}" == "off" ]; then
        i2cset -m $mask -y -r ${NUM_MUX2_CHAN7_DEVICE} $i2cAddr $ioPort 0x00
    else
        echo "Invalid Parameters, Exit!!!"
        _help
        exit ${FALSE}
    fi

    echo "done..."
}

#Set FAN LED
function _i2c_fan_led {
    if [ "${COLOR_LED}" == "green" ] && [ "${ONOFF_LED}" == "on" ]; then
        i2cset -m 0x08 -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0x00
    elif [ "${COLOR_LED}" == "green" ] && [ "${ONOFF_LED}" == "off" ]; then
        i2cset -m 0x08 -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    elif [ "${COLOR_LED}" == "amber" ] && [ "${ONOFF_LED}" == "on" ]; then
        i2cset -m 0x04 -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0x00
    elif [ "${COLOR_LED}" == "amber" ] && [ "${ONOFF_LED}" == "off" ]; then
        i2cset -m 0x04 -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    else
        echo "Invalid Parameters, Exit!!!"
        _help
        exit ${FALSE}
    fi

    echo "done..."
}

#Set PSU1 LED
function _i2c_psu1_led {
    if [ "${COLOR_LED}" == "green" ] && [ "${ONOFF_LED}" == "on" ]; then
        i2cset -m 0x02 -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0x00
    elif [ "${COLOR_LED}" == "green" ] && [ "${ONOFF_LED}" == "off" ]; then
        i2cset -m 0x02 -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    elif [ "${COLOR_LED}" == "amber" ] && [ "${ONOFF_LED}" == "on" ]; then
        i2cset -m 0x01 -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0x00
    elif [ "${COLOR_LED}" == "amber" ] && [ "${ONOFF_LED}" == "off" ]; then
        i2cset -m 0x01 -y -r ${NUM_MUX1_CHAN7_DEVICE} 0x22 2 0xFF
    else
        echo "Invalid Parameters, Exit!!!"
        _help
        exit ${FALSE}
    fi

    echo "done..."
}

#Get Board Version and Type
function _i2c_board_type_get {
    boardType=`i2cget -y ${NUM_I801_DEVICE} 0x33 0x00`
    boardBuildRev=$((($boardType) & 0x03))
    boardHwRev=$((($boardType) >> 2 & 0x03))
    boardId=$((($boardType) >> 4))
    printf "BOARD_ID is 0x%02x, HW Rev %d, Build Rev %d\n" $boardId $boardHwRev $boardBuildRev

}

#Get CPLD Version
function _i2c_cpld_version {
    cpldRev=`i2cget -y ${NUM_I801_DEVICE} 0x33 0x01`
    cpldRelease=$((($cpldRev) >> 6 & 0x01))
    cpldVersion=$((($cpldRev) & 0x3F))
    printf "CPLD is %s version(0:RD 1:Release), Revision is 0x%02x\n" $cpldRelease $cpldVersion

}

#Get PSU Status
function _i2c_psu_status {
    psuPresent=`i2cget -y ${NUM_I801_DEVICE} 0x33 0x03`
    psu1Exist=$(($((($psuPresent) & 0x01))?0:1))
    psu2Exist=$(($((($psuPresent) & 0x02))?0:1))
    psuPwGood=`i2cget -y ${NUM_I801_DEVICE} 0x33 0x02`
    psu1PwGood=$(($((($psuPwGood) >> 3 & 0x01))?1:0))
    psu2PwGood=$(($((($psuPwGood) >> 3 & 0x02))?1:0))
    printf "PSU1 Exist:%x PSU1 PW Good:%d\n" $psu1Exist $psu1PwGood
    printf "PSU2 Exist:%d PSU2 PW Good:%d\n" $psu2Exist $psu2PwGood
}

#Get Front Sensor Temperature
function _i2c_front_temp {
    #Front MAC
    i2cset -y -r ${NUM_I801_DEVICE} 0x2F 0x00 0x80
    Data1=`i2cget -y ${NUM_I801_DEVICE} 0x2F 0x21`
    Data2=`i2cget -y ${NUM_I801_DEVICE} 0x2F 0x3C`
    isPositive=$(($((($Data1) & 0x80))?1:0))
    printf "Front MAC Temperature: "
    if [ "$isPositive" = "1" ]
    then
        cTemp=$(( $(( $Data1 << 2 )) + $(( $(( $Data2 & 0xC0 >> 6 )) ^ 0x3FF )) + 1 ))
        dTemp=$(( $(( $cTemp & 0x03 )) * 25 ))
        intTemp=$(( $cTemp >> 2 ))

        printf "%c%d.%02d oC\n" "-" $intTemp $dTemp
    else
        dTemp=$(( $(( $Data2 & 0xC0 >> 6 )) * 25 ))
        intTemp=$Data1
        printf "%c%d.%02d oC\n" "+" $intTemp $dTemp
    fi
}

#Get Rear Sensor Temperature
function _i2c_rear_temp {
    #Rear MAC
    i2cset -y -r ${NUM_I801_DEVICE} 0x2F 0x00 0x80
    Data1=`i2cget -y ${NUM_I801_DEVICE} 0x2F 0x22`
    Data2=`i2cget -y ${NUM_I801_DEVICE} 0x2F 0x3C`
    isPositive=$(($((($Data1) & 0x80))?1:0))
    printf "Rear MAC Temperature: "
    if [ "$isPositive" = "1" ]
    then
        cTemp=$(( $(( $Data1 << 2 )) + $(( $(( $Data2 & 0xC0 >> 6 )) ^ 0x3FF )) + 1 ))
        dTemp=$(( $(( $cTemp & 0x03 )) * 25 ))
        intTemp=$(( $cTemp >> 2 ))

        printf "%c%d.%02d oC\n" "-" $intTemp $dTemp
    else
        dTemp=$(( $(( $Data2 & 0xC0 >> 6 )) * 25 ))
        intTemp=$Data1
        printf "%c%d.%02d oC\n" "+" $intTemp $dTemp
    fi
}

#Main Function
function _main {
    tart_time_str=`date`
    start_time_sec=$(date +%s)

    if [ "${EXEC_FUNC}" == "help" ]; then
        _help
    elif [ "${EXEC_FUNC}" == "i2c_init" ]; then
        _i2c_init
    elif [ "${EXEC_FUNC}" == "i2c_deinit" ]; then
        _i2c_deinit
    elif [ "${EXEC_FUNC}" == "i2c_temp_init" ]; then
        _i2c_temp_init
    elif [ "${EXEC_FUNC}" == "i2c_fan_init" ]; then
        _i2c_fan_init
    elif [ "${EXEC_FUNC}" == "i2c_volmon_init" ]; then
        _i2c_volmon_init
    elif [ "${EXEC_FUNC}" == "i2c_io_exp_init" ]; then
        _i2c_io_exp_init
    elif [ "${EXEC_FUNC}" == "i2c_gpio_init" ]; then
        _i2c_gpio_init
    elif [ "${EXEC_FUNC}" == "i2c_gpio_deinit" ]; then
        _i2c_gpio_deinit
    elif [ "${EXEC_FUNC}" == "i2c_led_test" ]; then
        _i2c_led_test
    elif [ "${EXEC_FUNC}" == "i2c_mb_eeprom_get" ]; then
        _i2c_mb_eeprom_get
    elif [ "${EXEC_FUNC}" == "i2c_psu_eeprom_get" ]; then
        _i2c_psu_eeprom_get
    elif [ "${EXEC_FUNC}" == "i2c_qsfp_eeprom_get" ]; then
        _i2c_qsfp_eeprom_get
    elif [ "${EXEC_FUNC}" == "i2c_led_psu_status_set" ]; then
        _i2c_led_psu_status_set
    elif [ "${EXEC_FUNC}" == "i2c_led_fan_status_set" ]; then
        _i2c_led_fan_status_set
    elif [ "${EXEC_FUNC}" == "i2c_led_fan_tray_status_set" ]; then
        _i2c_led_fan_tray_status_set
    elif [ "${EXEC_FUNC}" == "i2c_sys_led" ]; then
        _i2c_sys_led
    elif [ "${EXEC_FUNC}" == "i2c_fan_led" ]; then
        _i2c_fan_led
    elif [ "${EXEC_FUNC}" == "i2c_fan_tray_led" ]; then
        _i2c_fan_tray_led
    elif [ "${EXEC_FUNC}" == "i2c_psu1_led" ]; then
        _i2c_psu1_led
    elif [ "${EXEC_FUNC}" == "i2c_psu2_led" ]; then
        _i2c_psu2_led
    elif [ "${EXEC_FUNC}" == "i2c_board_type_get" ]; then
        _i2c_board_type_get
    elif [ "${EXEC_FUNC}" == "i2c_cpld_version" ]; then
        _i2c_cpld_version
    elif [ "${EXEC_FUNC}" == "i2c_psu_status" ]; then
        _i2c_psu_status
    elif [ "${EXEC_FUNC}" == "i2c_front_temp" ]; then
        _i2c_front_temp
    elif [ "${EXEC_FUNC}" == "i2c_rear_temp" ]; then
        _i2c_rear_temp
    elif [ "${EXEC_FUNC}" == "i2c_test_all" ]; then
        _i2c_init
        _i2c_temp_init
        _i2c_fan_init
        _i2c_io_exp_init
        _i2c_led_test
        _i2c_psu_eeprom_get
        _i2c_mb_eeprom_get
        _i2c_board_type_get
        _i2c_cpld_version
        _i2c_psu_status
    else
        echo "Invalid Parameters, Exit!!!"
        _help
        exit ${FALSE}
    fi

    end_time_str=`date`
    end_time_sec=$(date +%s)
    diff_time=$[ ${end_time_sec} - ${start_time_sec} ]
    echo "Start Time: ${start_time_str} (${start_time_sec})"
    echo "End Time  : ${end_time_str} (${end_time_sec})"
    echo "Total Execution Time: ${diff_time} sec"

    echo "done!!!"
}

_main
