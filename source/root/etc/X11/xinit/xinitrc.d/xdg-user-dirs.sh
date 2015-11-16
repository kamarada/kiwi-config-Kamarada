#!/bin/sh
/usr/bin/xdg-user-dirs-update

if [ ! -e "$HOME/.xdg-user-dirs-has-not-run-yet" ]; then
    exit 0
fi

desktop="`xdg-user-dir DESKTOP 2>/dev/null`"
if test -z "$desktop"; then
    desktop=$HOME/Desktop
fi
if [ -d "$desktop" -a ! -e "$desktop/.directory" -a -e "/usr/share/kde4/config/SuSE/default/desktop.directory" ]; then
    cp /usr/share/kde4/config/SuSE/default/desktop.directory "$desktop/.directory"
fi

documents="`xdg-user-dir DOCUMENTS 2>/dev/null`"
if test -z "$documents"; then
    documents=$HOME/Documents
fi
if [ -d "$documents" -a ! -e "$documents/.directory" -a -e "/usr/share/kde4/config/SuSE/default/documents.directory" ]; then
    cp /usr/share/kde4/config/SuSE/default/documents.directory "$documents/.directory"
fi

downloads="`xdg-user-dir DOWNLOAD 2>/dev/null`"
if test -z "$downloads"; then
    downloads=$HOME/Downloads
fi
if [ -d "$downloads" -a ! -e "$downloads/.directory" -a -e "/usr/share/kde4/config/SuSE/default/downloads.directory" ]; then
    cp /usr/share/kde4/config/SuSE/default/downloads.directory "$downloads/.directory"
fi

music="`xdg-user-dir MUSIC 2>/dev/null`"
if test -z "$music"; then
    music=$HOME/Music
fi
if [ -d "$music" -a ! -e "$music/.directory" -a -e "/usr/share/kde4/config/SuSE/default/music.directory" ]; then
    cp /usr/share/kde4/config/SuSE/default/music.directory "$music/.directory"
fi

pictures="`xdg-user-dir PICTURES 2>/dev/null`"
if test -z "$pictures"; then
    pictures=$HOME/Pictures
fi
if [ -d "$pictures" -a ! -e "$pictures/.directory" -a -e "/usr/share/kde4/config/SuSE/default/pictures.directory" ]; then
    cp /usr/share/kde4/config/SuSE/default/pictures.directory "$pictures/.directory"
fi

public="`xdg-user-dir PUBLICSHARE 2>/dev/null`"
if test -z "$public"; then
    public=$HOME/Public
fi
if [ -d "$public" -a ! -e "$public/.directory" -a -e "/usr/share/kde4/config/SuSE/default/public.directory" ]; then
    cp /usr/share/kde4/config/SuSE/default/public.directory "$public/.directory"
fi

templates="`xdg-user-dir TEMPLATES 2>/dev/null`"
if test -z "$templates"; then
    templates=$HOME/Templates
fi
if [ -d "$templates" -a ! -e "$templates/.directory" -a -e "/usr/share/kde4/config/SuSE/default/templates.directory" ]; then
    cp /usr/share/kde4/config/SuSE/default/templates.directory "$templates/.directory"
fi

videos="`xdg-user-dir VIDEOS 2>/dev/null`"
if test -z "$videos"; then
    videos=$HOME/Videos
fi
if [ -d "$videos" -a ! -e "$videos/.directory" -a -e "/usr/share/kde4/config/SuSE/default/videos.directory" ]; then
    cp /usr/share/kde4/config/SuSE/default/videos.directory "$videos/.directory"
fi

if [ ! -e "$desktop/Home.desktop" -a -e "/usr/share/kde4/config/SuSE/default/Home.desktop" ]; then
    cp /usr/share/kde4/config/SuSE/default/Home.desktop "$desktop/"
fi

if [ -e "/usr/bin/firefox" -a ! -e "$desktop/MozillaFirefox.desktop" -a -e "/usr/share/kde4/config/SuSE/default/MozillaFirefox.desktop" ]; then
    cp /usr/share/kde4/config/SuSE/default/MozillaFirefox.desktop "$desktop/"
    chmod u+x "$desktop/MozillaFirefox.desktop" 2>/dev/null
fi

if [ -e "/usr/bin/oofromtemplate" -a  ! -e "$desktop/Office.desktop" -a -e "/usr/share/kde4/config/SuSE/default/Office.desktop" ]; then
    cp /usr/share/kde4/config/SuSE/default/Office.desktop "$desktop/"
    chmod u+x "$desktop/Office.desktop" 2>/dev/null
fi

if [ -e "/usr/bin/SUSEgreeter" -a ! -e "$desktop/SuSE.desktop" -a -e "/usr/share/kde4/config/SuSE/default/SuSE.desktop" ]; then
    cp /usr/share/kde4/config/SuSE/default/SuSE.desktop "$desktop/"
    chmod u+x "$desktop/SuSE.desktop" 2>/dev/null
fi

if [ ! -e "$desktop/Support.desktop" -a -e "/usr/share/kde4/config/SuSE/default/Support.desktop" ]; then
    cp /usr/share/kde4/config/SuSE/default/Support.desktop "$desktop/"
    chmod u+x "$desktop/Support.desktop" 2>/dev/null
fi

if [ -e "/usr/share/applications/YaST2/live-installer.desktop" -a ! -e "$desktop/live-installer.desktop" -a -e "/usr/share/kde4/config/SuSE/default/live-installer.desktop" ]; then
    cp /usr/share/kde4/config/SuSE/default/live-installer.desktop "$desktop/"
    chmod u+x "$desktop/live-installer.desktop"
fi

if [ ! -e "$desktop/trash.desktop" -a -e "/usr/share/kde4/config/SuSE/default/trash.desktop" ]; then
    cp /usr/share/kde4/config/SuSE/default/trash.desktop "$desktop/"
fi

if [ ! -e "$desktop/org.kde.kinfocenter.desktop" -a -e "/usr/share/applications/org.kde.kinfocenter.desktop" ]; then
    cp /usr/share/applications/org.kde.kinfocenter.desktop "$desktop/"
    chmod u+x "$desktop/org.kde.kinfocenter.desktop" 2>/dev/null
fi

rm $HOME/.xdg-user-dirs-has-not-run-yet
