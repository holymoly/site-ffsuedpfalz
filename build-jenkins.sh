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
export GLUON_COMMIT=v2016.2.2
export GLUON_RELEASE=$GLUON_COMMIT-`date '+%Y%m%d'`

echo "Building gluon $GLUON_COMMIT -> $GLUON_RELEASE"

# Verzeichnis für Gluon-Repo erstellen und initialisieren
echo  /temp/{env.BRANCH_NAME}

test -d "/temp/{env.BRANCH_NAME}" || git clone "$GLUON_URL" "/temp/{env.BRANCH_NAME}"
cd "/temp/${env.BRANCH_NAME}"
git fetch
git checkout -f $GLUON_COMMIT

# Site config kopieren
test -d "/temp/${env.BRANCH_NAME}/site" && rm -r "/temp/${env.BRANCH_NAME}/site"
mkdir "/temp/${env.BRANCH_NAME}/site"
cp "${WORKSPACE}/modules" "/temp/${env.BRANCH_NAME}/site/"
cp "${WORKSPACE}/site.mk" "/temp/${env.BRANCH_NAME}/site/"
cp "${WORKSPACE}/site.conf" "/temp/${env.BRANCH_NAME}/site/"

# Gluon Pakete aktualisieren und Build ausfuhren
cd "/temp/${env.BRANCH_NAME}"
make update "GLUON_RELEASE=$GLUON_RELEASE"
make clean V=s GLUON_TARGET=ar71xx-generic
make -j5 V=s GLUON_TARGET=ar71xx-generic GLUON_BRANCH=experimental "GLUON_RELEASE=$GLUON_RELEASE"
# make V=s "GLUON_RELEASE=$GLUON_RELEASE" "GLUON_BRANCH=stable"

# Manifest für Autoupdater erstellen und mit den Key des Servers unterschreiben
# Der private Schlüssel des Servers muss in $JENKINS_HOME/secret liegen und das
# Tools 'ecdsasign' muss auf dem Server verfügbar sein.
# Repo: https://github.com/tcatm/ecdsautils
