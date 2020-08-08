#!/bin/bash

DATETIME=`date +%Y%m%d-%H%M`
DIRECTORY=/mnt/moodle.bak
SITENAME=JAM-VLE
siteDIRECTORY=/var/www/html/moodle/

showinfo(){
    echo "\n\n########################################"
    echo "##### M-backup start $DATETIME #####"
    echo "########################################\n"
    echo "This script will perform the following steps to backup your moodle installation directory:"
    echo "\t- Mount a backup space at $DIRECTORY."
    echo "\t- Archive the moodle directory to $DIRECTORY/siteBackup/ and append timestamp to file name."
    echo "\t- Unmount the backup directory.\n"
}

mountDirectory(){
    echo "\n##### Mounting backup directory. #####"
    if mount $DIRECTORY; then
        echo "\n##### `date +%Y%m%d-%H%M` : Backup space mounted at $DIRECTORY #####"
        return 0
    else
        echo "\n##### `date +%Y%m%d-%H%M` : Failed to mount $DIRECTORY #####"
        return 1
    fi
}

tarSITE(){
    #create the siteBackup directory if missing
    mkdir -p $DIRECTORY/siteBackup
    cd $siteDIRECTORY/..
    echo "\n##### Gathering and Compressing Moodle directory. #####"
    if tar czf $DIRECTORY/siteBackup/$SITENAME-siteBackup_$DATETIME.tar.gz moodle/; then
        echo "\n##### `date +%Y%m%d-%H%M` : Successfully archived to $DIRECTORY/siteBackup/$SITENAME-siteBackup_$DATETIME.tar.gz #####"
        return 0
    else
        echo "\n##### `date +%Y%m%d-%H%M` : An error occured while creating archive $SITENAME-siteBackup_$DATETIME.tar.gz #####"
        sleep 5
        if rm $DIRECTORY/siteBackup/$SITENAME-siteBackup_$DATETIME.tar.gz; then
            echo "\n##### `date +%Y%m%d-%H%M` : $SITENAME-siteBackup_$DATETIME.tar.gz removed #####"
        fi
        return 1
    fi
}

umountDirectory(){
    echo "\n##### Unmounting backup directory. #####"
    if umount $DIRECTORY; then
        echo "\n##### `date +%Y%m%d-%H%M` : Backup space successfully unmounted #####"
        return 0
    else
        echo "\n##### `date +%Y%m%d-%H%M` : Failed to unmount $DIRECTORY #####"
        return 1
    fi
}

#Main Program
showinfo
if mountpoint $DIRECTORY; then
    echo "\n##### `date +%Y%m%d-%H%M` : Backup space already mounted at $DIRECTORY #####"
    tarSITE
    sleep 5
    umountDirectory
else
    if mountDirectory; then
        tarSITE
        sleep 5
        umountDirectory
    else
        echo "\n##### `date +%Y%m%d-%H%M` : Backup process failed! Stopping script... #####"
        sleep 5
    fi
fi

echo "\n########################################"
echo "##### M-backup ended `date +%Y%m%d-%H%M` #####"
echo "########################################\n\n"


