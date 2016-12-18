#!/bin/bash
#######################################################################
# borg based backup photo
#
#  Kai Yuan  2016-12-18  
#######################################################################
TARGET=/run/media/kent/SK_BACKUP/borgBackup
SRC="/media/Data/=MyPictures="
echo "[INFO] backing up pictures"
export BORG_PASSPHRASE='kent'

borg create -v --stats                    \
		$TARGET/PHOTO::'photo_{now:%y-%m-%d}' $SRC \

