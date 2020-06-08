#!/bin/bash

DATETIME=`date +%Y%m%d-%H%M`
DIRECTORY=/mnt/moodle.bak
#KINDLY NOTE: Include the trailling / at the end of the MD directory path below, failure to do so may cause undesired directory structure with RSYNC.  
MD=/var/moodledata/

showinfo(){
    echo "\n\n########################################"
    echo "##### MDbackup start $DATETIME #####"
    echo "########################################\n"
    echo "This script will perform the following steps to backup your moodledata directory:"
    echo "\t- Mount a backup space at $DIRECTORY."
    echo "\t- Perfom RSYNC on the moodledata directory ($MD) to $DIRECTORY/mdBackup"
    echo "\t- Unmount the backup directory.\n"
}

mountDirectory(){
    echo "\n##### Mounting backup directory. #####"
    if mount $DIRECTORY; then
        echo "\n##### Backup space mounted at $DIRECTORY #####"
        return 0
    else
        echo "\n##### Failed to mount $DIRECTORY #####"
        return 1
    fi
}

rsyncMD(){
    #create the mdBackup directory if missing
    mkdir -p $DIRECTORY/mdBackup
    echo "\n##### RSYNCing MoodleData. #####"
    if rsync -a --delete-after $MD $DIRECTORY/mdBackup; then
        echo "\n##### $MD successfully synced to $DIRECTORY/mdBackup/ #####"
        return 0
    else
        echo "\n##### An error occured while syncing $MD to $DIRECTORY/mdBackup/ #####"
        return 1
    fi
}

umountDirectory(){
    echo "\n##### Unmounting backup directory. #####"
    if umount $DIRECTORY; then
        echo "\n##### Backup space successfully unmounted #####"
        return 0
    else
        echo "\n##### Failed to unmount $DIRECTORY #####"
        return 1
    fi
}

#Main Program
showinfo
if mountpoint $DIRECTORY; then
    echo "\n##### Backup space already mounted at $DIRECTORY #####"
    rsyncMD
    sleep 5
    umountDirectory
else
    if mountDirectory; then
        rsyncMD
        sleep 5
        umountDirectory
    else
        echo "\n##### Backup process failed! Stopping script... #####"
        sleep 5
fi
CURDATETIME=`date +%Y%m%d-%H%M`
echo "\n########################################"
echo "##### MDbackup ended $CURDATETIME #####"
echo "########################################\n\n"


