#!/bin/bash
#================
# FILE          : config.sh
#----------------
# PROJECT       : OpenSuSE KIWI Image System
# COPYRIGHT     : (c) 2006 SUSE LINUX Products GmbH. All rights reserved
#               :
# AUTHOR        : Marcus Schaefer <ms@suse.de>
#               :
# BELONGS TO    : Operating System images
#               :
# DESCRIPTION   : configuration script for SUSE based
#               : operating systems
#               :
#               :
# STATUS        : BETA
#----------------
#======================================
# Functions...
#--------------------------------------

# The .kconfig file allows to make use of a common set of functions.
# Functions specific to SUSE Linux specific begin with the name suse.
# Functions applicable to all linux systems starts with the name base.
test -f /.kconfig && . /.kconfig

# The .profile environment file contains a specific set of variables.
# Some of the functions above makes use of the variables.
test -f /.profile && . /.profile

# Exit immediately if a command exits with a non-zero status.
# set -e

# Print commands and their arguments as they are executed.
set -x

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$name]..."

#======================================
# SuSEconfig
#--------------------------------------
echo "** Running suseConfig..."
suseConfig

echo "** Running ldconfig..."
/sbin/ldconfig

#======================================
# Setup default runlevel
#--------------------------------------
baseSetRunlevel 5

#======================================
# Add missing gpg keys to rpm
#--------------------------------------
suseImportBuildKey

sed --in-place -e 's/# solver.onlyRequires.*/solver.onlyRequires = true/' /etc/zypp/zypp.conf

#======================================
# Sysconfig Update
#--------------------------------------
echo '** Update sysconfig entries...'
baseUpdateSysConfig /etc/sysconfig/keyboard KEYTABLE english-us
baseUpdateSysConfig /etc/sysconfig/network/config FIREWALL yes
baseUpdateSysConfig /etc/sysconfig/console CONSOLE_FONT lat9w-16.psfu
baseUpdateSysConfig /etc/sysconfig/displaymanager DISPLAYMANAGER_AUTOLOGIN linux
baseUpdateSysConfig /etc/sysconfig/displaymanager DISPLAYMANAGER sddm
baseUpdateSysConfig /etc/sysconfig/windowmanager DEFAULT_WM plasma5

#======================================
# SSL Certificates Configuration
#--------------------------------------
echo '** Rehashing SSL Certificates...'
c_rehash

# Use NetworkManager to configure the network at run-time
systemctl -f disable wicked
systemctl -f enable NetworkManager

# Enable firewall
systemctl -f enable SuSEfirewall2

# Disable SSH
systemctl -f disable sshd

# Some KDE settings
for script in /usr/share/opensuse-kiwi/live_user_scripts/*.sh; do
    if test -f $script; then
        su - linux -c "/bin/bash $script"
    fi
done
