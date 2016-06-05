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

# Create an empty file /var/log/config.log
# exec | tee /var/log/config.log

# Redirect stderr of all commands to stdout
# exec 2>&1

# Remove any package starting with package-lists-
# pl=`rpmqpack | grep package-lists-` || true
# test -z "$pl" || rpm -e $pl

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

#======================================
# Mount system filesystems
#--------------------------------------
# baseMount

#======================================
# Call configuration code/functions
#--------------------------------------

# SuSEconfig
echo "** Running suseConfig..."
suseConfig
# baseUpdateSysConfig /etc/sysconfig/language RC_LANG "en_US.UTF-8"

echo "** Running ldconfig..."
/sbin/ldconfig

# Setup baseproduct link
suseSetupProduct

# Enable/disable services

for s in sshd cron wicked purge-kernels; do
    systemctl -f disable $s
done

for s in NetworkManager SuSEfirewall2; do
    systemctl -f enable $s
done

# cd /
# if test -e /etc/YaST2/liveinstall.patch; then
#     patch -p0 < /etc/YaST2/liveinstall.patch
# fi

# for i in /rpmkeys/gpg*.asc; do 
#     # the import fails if kiwi already had this key
#     rpm --import $i || true
#     rm $i
# done
# rmdir /rpmkeys

# Add missing GPG keys to RPM
suseImportBuildKey

# Remove repository metadata
# rm -rf /var/cache/zypp/raw/*

# Add repositories
# bash -x /var/lib/livecd/geturls.sh
# rm /var/lib/livecd/geturls.sh
zypper addrepo -f -n "openSUSE-Leap-42.1-Update" http://download.opensuse.org/update/leap/42.1/oss/ "repo-update"
zypper addrepo -f -n "openSUSE-Leap-42.1-Update-Non-Oss" http://download.opensuse.org/update/leap/42.1/non-oss/ "repo-update-non-oss"
zypper addrepo -f -n "openSUSE-Leap-42.1-Oss" http://download.opensuse.org/distribution/leap/42.1/repo/oss/ "repo-oss"
zypper addrepo -d -f -n "openSUSE-Leap-42.1-Non-Oss" http://download.opensuse.org/distribution/leap/42.1/repo/non-oss/ "repo-non-oss"
zypper addrepo -d -f -n "openSUSE-Leap-42.1-Debug" http://download.opensuse.org/debug/distribution/leap/42.1/repo/oss/ "repo-debug"
zypper addrepo -d -f -n "openSUSE-Leap-42.1-Debug-Non-Oss" http://download.opensuse.org/debug/distribution/leap/42.1/repo/non-oss/ "repo-debug-non-oss"
zypper addrepo -d -f -n "openSUSE-Leap-42.1-Update-Debug" http://download.opensuse.org/debug/update/leap/42.1/oss/ "repo-debug-update"
zypper addrepo -d -f -n "openSUSE-Leap-42.1-Update-Debug-Non-Oss" http://download.opensuse.org/debug/update/leap/42.1/non-oss/ "repo-debug-update-non-oss"
zypper addrepo -d -f -n "openSUSE-Leap-42.1-Source" http://download.opensuse.org/source/distribution/leap/42.1/repo/oss/ "repo-source"
zypper addrepo -d -f -n "openSUSE-Leap-42.1-Source-Non-Oss" http://download.opensuse.org/source/distribution/leap/42.1/repo/non-oss/ "repo-source-non-oss"

# Only required packages are installed
sed --in-place -e 's/# solver.onlyRequires.*/solver.onlyRequires = true/' /etc/zypp/zypp.conf

# /etc/sudoers hack to fix #297695
# (Installation Live CD: no need to ask for password of root)
sed -i -e "s/ALL ALL=(ALL) ALL/ALL ALL=(ALL) NOPASSWD: ALL/" /etc/sudoers 
chmod 0440 /etc/sudoers

# Create LiveDVD user
/usr/sbin/useradd -m -u 999 linux -c "LiveDVD User" -p ""

# Delete passwords
passwd -d root
passwd -d linux

# Empty password is OK
pam-config -a --nullok

# Clear zypper log
: > /var/log/zypper.log

# mv /var/lib/livecd/*.pdf /home/linux || true
# rmdir /var/lib/livecd || true

chown -R linux /home/linux

# Check and set file permissions
chkstat --system --set

for script in /usr/share/opensuse-kiwi/live_user_scripts/*.sh; do
    if test -f $script; then
        su - linux -c "/bin/bash $script"
    fi
done

# Clear package cache
# rm -rf /var/cache/zypp/packages

# bug 544314, we only want to disable the bit in common-auth-pc
sed -i -e 's,^\(.*pam_gnome_keyring.so.*\),#\1,'  /etc/pam.d/common-auth-pc

#USB /usr/bin/correct_live_for_reboot usb
#USB /usr/bin/correct_live_install usb

# Setup default target, with GUI
# ln -s /usr/lib/systemd/system/runlevel5.target /etc/systemd/system/default.target
baseSetRunlevel 5

# Sysconfig update
echo '** Update sysconfig entries...'

baseUpdateSysConfig /etc/sysconfig/displaymanager DISPLAYMANAGER "sddm"
baseUpdateSysConfig /etc/sysconfig/displaymanager DISPLAYMANAGER_AUTOLOGIN "linux"
baseUpdateSysConfig /etc/sysconfig/network/config FIREWALL "yes"
baseUpdateSysConfig /etc/sysconfig/windowmanager DEFAULT_WM "plasma5"

# bug 891183 yast2 live-installer --gtk segfaults
# baseUpdateSysConfig /etc/sysconfig/yast2 WANTED_GUI qt

# SSL certificates configuration
echo '** Rehashing SSL Certificates...'
c_rehash

# Remove package docs
rm -rf /usr/share/doc/packages/*
# rm -rf /usr/share/doc/manual/*
# rm -rf /opt/kde*

# YaST Firstboot
mv /etc/YaST2/firstboot.xml /etc/YaST2/firstboot.xml.suse
cp /etc/YaST2/firstboot.xml.kamarada /etc/YaST2/firstboot.xml
touch /var/lib/YaST2/reconfig_system
baseUpdateSysConfig /etc/sysconfig/firstboot FIRSTBOOT_WELCOME_DIR "/usr/share/firstboot/"

#======================================
# Umount kernel filesystems
#--------------------------------------
# baseCleanMount

#======================================
# Exit safely
#--------------------------------------
exit 0
