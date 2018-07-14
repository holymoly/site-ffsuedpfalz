#!/bin/sh
#
###############################################################################################
# Jenkins-Buildscript zu erstellung der Images
#
# Dieses Script wird nach jedem Push auf dem Freifunk Buildserver ausgführt
# und erstelt die Images komplett neu.
#
# Durch den Jenkins-Server werden folgende Systemvariablem gesetzt:
# $WORKSPACE - Arbeitsverzeichnis, hierhin wurde dieses repo geclont
# $JENKINS_HOME - TBD
# $BUILD_NUMBER - Nummer des aktuellen Buildvorganges (wird in der site.conf verwendet)
#
###############################################################################################
# Based on https://github.com/FreiFunkMuenster/site-ffms/blob/master/build-jenkins.sh
###############################################################################################

set -e

# Globale Einstellungen
export GLUON_URL=https://github.com/freifunk-gluon/gluon.git
export GLUON_COMMIT=v2017.1.6
export GLUON_RELEASE=$GLUON_COMMIT-`date '+%Y%m%d'`

echo "Building gluon $GLUON_COMMIT -> $GLUON_RELEASE"

# Verzeichnis für Gluon-Repo erstellen und initialisieren
echo  "/temp/$1"

test -d "/temp/$1" || git clone "$GLUON_URL" "/temp/$1"
cd "/temp/$1"
git fetch
git checkout -f $GLUON_COMMIT

# Site config kopieren
test -d "/temp/$1/site" && rm -r "/temp/$1/site"
mkdir "/temp/$1/site"
cp "${WORKSPACE}/modules" "/temp/$1/site/"
cp "${WORKSPACE}/site.mk" "/temp/$1/site/"
cp "${WORKSPACE}/site.conf" "/temp/$1/site/"

# Gluon Pakete aktualisieren und Build ausfuhren
cd "/temp/$1"

#temporärer fix
#test -d /temp/$1/openwrt/ || mkdir /temp/$1/openwrt/
#test -d /temp/$1/openwrt/dl/ || mkdir /temp/$1/openwrt/dl/
#test -f "/temp/$1/openwrt/dl/linux-3.18.44.tar.xz" || wget https://www.kernel.org/pub/linux/kernel/v3.0/linux-3.18.44.tar.xz -O "/temp/$1/openwrt/dl/linux-3.18.44.tar.xz"

make update "GLUON_RELEASE=$GLUON_RELEASE"
make clean V=s GLUON_TARGET=ar71xx-generic
make -j1 V=s GLUON_TARGET=ar71xx-generic GLUON_BRANCH=experimental "GLUON_RELEASE=$GLUON_RELEASE"
#make -j1 V=s GLUON_TARGET=ar71xx-tiny GLUON_BRANCH=experimental "GLUON_RELEASE=$GLUON_RELEASE"
#make -j1 V=s GLUON_TARGET=ar71xx-nand GLUON_BRANCH=experimental "GLUON_RELEASE=$GLUON_RELEASE"
#make -j1 V=s GLUON_TARGET=brcm2708-bcm2708 GLUON_BRANCH=experimental "GLUON_RELEASE=$GLUON_RELEASE"
#make -j1 V=s GLUON_TARGET=brcm2708-bcm2709 GLUON_BRANCH=experimental "GLUON_RELEASE=$GLUON_RELEASE"
#make -j1 V=s GLUON_TARGET=mpc85xx-generic GLUON_BRANCH=experimental "GLUON_RELEASE=$GLUON_RELEASE"
#make -j1 V=s GLUON_TARGET=x86-generic GLUON_BRANCH=experimental "GLUON_RELEASE=$GLUON_RELEASE"
#make -j1 V=s GLUON_TARGET=x86-geode GLUON_BRANCH=experimental "GLUON_RELEASE=$GLUON_RELEASE"
#make -j1 V=s GLUON_TARGET=x86-64 GLUON_BRANCH=experimental "GLUON_RELEASE=$GLUON_RELEASE"
# make V=s "GLUON_RELEASE=$GLUON_RELEASE" "GLUON_BRANCH=stable"
cp -r "/temp/$1/output" "${WORKSPACE}/"
# Manifest für Autoupdater erstellen und mit den Key des Servers unterschreiben
# Der private Schlüssel des Servers muss in $JENKINS_HOME/secret liegen und das
# Tools 'ecdsasign' muss auf dem Server verfügbar sein.
# Repo: https://github.com/tcatm/ecdsautils
