#!/bin/bash
#######################################################################
# borg based personal backup script
#
#  The backup is based on tar/gzip. Three partitions will be archived.
#  1- /  
#  2- /boot 
#  3- /home
# 
#  This script has hardcoded directories, therefore ONLY works to my
#  local machine.
#  
#  Kai Yuan  2016-12-18  
#######################################################################

BKALL=0
BKROOT=0
BKBOOT=0
BKHOME=0
DATESTR=$(date +%Y%m%d)
#TARGET=/run/media/kent/SK_BACKUP/borgBackup
TARGET=/media/borgBackup
PACMAN=$TARGET/pacmanPKG

#borg passphrase
export BORG_PASSPHRASE="kent"

# mv pacman packages to backup directory (root permission needed)
mvPacman(){
	echo "[INFO] move pacman pkgs (yaourt) ............. "
	cd /var/cache/pacman/pkg/
	mv * $PACMAN
	echo "[INFO] move pacman pkgs (yay) ............. "
	find /home/kent/.cache/yay -iname "*.xz" |xargs -I {} mv '{}' -t $PACMAN
	rm -rf /home/kent/.cache/yay/*

}

# backup / partition
backupRoot(){

    #exclude directories
    exBoot="--exclude=sh:/boot"
	exDhcpd="--exclude=sh:/var/lib/dhcpcd/proc"
    exHome="--exclude=sh:/home"
    exProc="--exclude=sh:/proc"
    exLost="--exclude=sh:/lost+found"
    exMnt="--exclude=sh:/mnt"
    exSys="--exclude=sh:/sys"
    exDev="--exclude=sh:/dev"
    exMedia="--exclude=sh:/media"
    exUsbMedia="--exclude=sh:/run/media"
    exTmp="--exclude=sh:/tmp"

    echo "[INFO] backing up / to ............. "

	borg create -pv --stats                    \
		$TARGET/root::'root_{now:%Y-%m-%d}' / \
		$exBoot $exHome $exProc $exLost $exMedia $exUsbMedia $exMnt $exSys $exDev $exTmp $exDhcpd

    [ $? == 0 ] && echo "[INFO] backup / finished."
    echo "----------------------------------------"
    
}




backupBoot(){
#exclude directories
    exLostFound="--exclude=/boot/lost+found"

    echo "[INFO] backing up /boot to ..........."

	borg create -v --stats                    \
		$TARGET/boot::'boot_{now:%Y-%m-%d}' /boot $exLostFound

   [ $? == 0 ] && echo "[INFO] backup /boot finished."
    echo "----------------------------------------"
}





backupHome(){
    
    # exclude directories
    exVBOX="--exclude=re:/home/kent/VirtualBox.*"
    exDropbox="--exclude=sh:/home/kent/Dropbox"
    exNextcloud="--exclude=sh:/home/kent/Nextcloud"
    exDownloads="--exclude=sh:/home/kent/downloads"
    exOthers="--exclude=sh:/home/kent/vboxShare"
	exCache="--exclude=sh:/home/kent/.cache"

    echo "[INFO] backing up /home partition"

    borg create -pv --stats $TARGET/home::'home_{now:%Y-%m-%d}' /home  \
		$exDownloads $exDropbox $exOthers $exVBOX $exCache $exNextcloud

    [ $? == 0 ] && echo "[INFO] backup /home finished."
    echo "----------------------------------------"
}



printUsage(){
    echo -e "\
        Usage: backup [OPTION]
               default: backup -r 

        OPTION
            -a  (same as -bmrp) backup all partitions ( /, /boot and /home )
            -b  only backup /boot partition
            -m  only backup /home partition
            -r  only backup /  partition (Default)
			-p  move pacman cached pkgs(under /var/cache/pacman/pkg) to /media/SK_BACKUP/borgBackup/pacmanPKG

            -h  print this information"

}






while getopts ":abmrph" opt
do
    case $opt in
        a) BKALL=1 ;;
        b) BKBOOT=1 ;;
        m) BKHOME=1 ;;
        r) BKROOT=1 ;;
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


#backup installed package, install as yaourt -S (<pkgs.list)
awk '!a[$0]++' <(pacman -Qeq) <(pacman -Qmq)|sort >"$TARGET/pkgs.list"

if [ "$BKALL" = "1" ]; then
    echo "$BKALL - bkall"
	mvPacman 
    backupBoot
    backupRoot
    backupHome
    exit 0
elif [ "$BKROOT" = "1" ]; then
	mvPacman 
    backupRoot

elif [ "$BKBOOT" = "1" ]; then 
    backupBoot

elif [ "$BKHOME" = "1" ]; then
    backupHome
fi


