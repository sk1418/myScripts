#!/bin/bash
#######################################################################
# tar based personal backup script
#
#  The backup is based on tar/gzip. Three partitions will be archived.
#  1- /  
#  2- /boot 
#  3- /home
# 
#  This script has hardcoded directories, therefore ONLY works to my
#  local machine.
#  
#  Kai Yuan  2010-08-29
#######################################################################
BKALL=0
BKROOT=0
BKBOOT=0
BKHOME=0
DATESTR=$(date +%Y%m%d)
TARGET=/run/media/kent/SK_BACKUP/Linux
PACMAN=$TARGET/pacmanPKG

# mv pacman packages to backup directory (root permission needed)
mvPacman(){
	cd /var/cache/pacman/pkg/
	pwd
	mv * $PACMAN
}

# backup / partition
backupRoot(){

    #exclude directories
    exBoot="--exclude=/boot"
    exHome="--exclude=/home"
    exProc="--exclude=/proc"
    exLost="--exclude=/lost+found"
    exMnt="--exclude=/mnt"
    exSys="--exclude=/sys"
    exDev="--exclude=/dev"
    exMedia="--exclude=/media"
    exUsbMedia="--exclude=/run/media"
    exTmp="--exclude=/tmp"

    echo "[INFO] backing up / to $1............. "
    tar cpzf $TARGET/root_$DATESTR.tgz / $exBoot $exHome $exProc $exLost $exMedia $exUsbMedia $exMnt $exSys $exDev $exTmp
    [ $? == 0 ] && echo "[INFO] backup / finished.  filename: root_$DATESTR.tgz"
    echo "----------------------------------------"
    
    
}




backupBoot(){
#exclude directories
    exLostFound="--exclude=/boot/lost+found"

    echo "[INFO] backing up /boot to $1..........."
    sudo tar cpzf $TARGET/boot_$DATESTR.tgz /boot $exLostFound
   [ $? == 0 ] && echo "[INFO] backup /boot finished.  filename: boot_$DATESTR.tgz"
    echo "----------------------------------------"
}





backupHome(){
    
    # exclude directories
    exVBOX="--exclude=/home/kent/VirtualBox\ VMs"
    exDropbox="--exclude=/home/kent/Dropbox"
    exDownloads="--exclude=/home/kent/downloads"
    exOthers="--exclude=/home/kent/Desktop/myTmp/vboxShare"

    echo "[INFO] backing up /home to $1, backup filename: home_$DATESTR.tgz"
    tar cpzf $TARGET/home_$DATESTR.tgz /home "$exVBOX" "$exDownloads" "$exDropbox" "$exOthers"
    [ $? == 0 ] && echo "[INFO] backup /home finished.  filename: home_$DATESTR.tgz"
    echo "----------------------------------------"
}



printUsage(){
    echo -e "\
        Usage: backup [OPTION]
               default: backup -r -t /media/SK_BACKUP/Linux

        OPTION
            -a  (same as -bmrp) backup all partitions ( /, /boot and /home )
            -b  only backup /boot partition
            -m  only backup /home partition
            -r  only backup /  partition (Default)
            -t  <target directory> The target directory to save the backup archive.(.tgz file) 
                Default target :/media/SK_BACKUP/Linux
                If the given directory doesn't exist, a new directory will be created. Any error during
                directory creation will stop the backup process.
			-p  move pacman cached pkgs(under /var/cache/pacman/pkg) to /media/SK_BACKUP/Linux/pacmanPKG

            -h  print this information"

}






while getopts ":t:abmrph" opt
do
    case $opt in
        a) BKALL=1 ;;
        b) BKBOOT=1 ;;
        m) BKHOME=1 ;;
        r) BKROOT=1 ;;
        t) if [ -z $OPTARG ]; then
                echo "-t option needs a target directory argument"
                exit 1
           else
                TARGET=$OPTARG
           fi 
           ;;
		p) mvPacman
			exit 0 ;;
        h) printUsage 
            exit 0 ;;
        ?) echo "unknown option"  
            exit 1
         ;;
    esac
done

#only root/sudo can execute this script
#if [ `id -u`!=0 ]; then
#    echo "[Error] You must run $0 as root!"
#    exit 1
#fi


# if no partition option was set, using -r (backup only / partition)
if [ $(($BKALL+$BKROOT+$BKBOOT+$BKHOME)) -eq 0 ]; then
    BKROOT=1
fi

# check if the target directory is valid
if [ ! -d $TARGET  ]; then
    echo "[INFO] target directory doesn't exist, creating directory: $TARGET"
    mkdir -p $TARGET
    if [ $?>0 ];then exit 1;fi
fi

#removing the last "/"
TARGET=${TARGET%/}

if [ "$BKALL" = "1" ]; then
    echo "$BKALL - bkall"
	mvPacman 
    backupBoot $TARGET
    backupRoot $TARGET
    backupHome $TARGET
    exit 0
elif [ "$BKROOT" = "1" ]; then
	mvPacman 
    backupRoot $TARGET

elif [ "$BKBOOT" = "1" ]; then 
    backupBoot $TARGET

elif [ "$BKHOME" = "1" ]; then
    backupHome $TARGET
fi


