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
set -e

# Print commands and their arguments as they are executed.
set -x

# Create an empty file /var/log/config.log
exec | tee /var/log/config.log

# Redirect stderr of all commands to stdout
exec 2>&1

# Removes any package starting with package-lists-
# pl=`rpmqpack | grep package-lists-` || true
# test -z "$pl" || rpm -e $pl

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

#======================================
# Mount system filesystems
#--------------------------------------
baseMount

#======================================
# Call configuration code/functions
#--------------------------------------

# Setup baseproduct link
suseSetupProduct

# Add missing GPG keys to RPM
suseImportBuildKey

for i in /rpmkeys/gpg*.asc; do 
    # the import fails if kiwi already had this key
    rpm --import $i || true
    rm $i
done
rmdir /rpmkeys

# Activate services
suseInsertService sshd

# Setup default target, multi-user
baseSetRunlevel 3

# remove package docs
rm -rf /usr/share/doc/packages/*
rm -rf /usr/share/doc/manual/*
rm -rf /opt/kde*

# SuSEconfig
suseConfig

# Remove repository metadata
rm -rf /var/cache/zypp/raw/*

# Add repositories
bash -x /var/lib/livecd/geturls.sh
rm /var/lib/livecd/geturls.sh

# Clear zypper log
: > /var/log/zypper.log

# Clear package cache
rm -rf /var/cache/zypp/packages

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount

#======================================
# Exit safely
#--------------------------------------
exit 0
