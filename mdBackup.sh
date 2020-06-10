#!/bin/bash

DATETIME=`date +%Y%m%d-%H%M`
DIRECTORY=/mnt/moodle.bak
SITENAME=JAM-VLE
mdDIRECTORY=/var/moodledata

showinfo(){
    echo "\n\n########################################"
    echo "##### MDbackup start $DATETIME #####"
    echo "########################################\n"
    echo "This script will perform the following steps to backup your moodledata directory:"
    echo "\t- Mount a backup space at $DIRECTORY."
    echo "\t- Archive the moodledata directory to $DIRECTORY/mdBackup/ and append timestamp to file name."
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

tarMD(){
    #create the mdBackup directory if missing
    mkdir -p $DIRECTORY/mdBackup
    cd $mdDIRECTORY/..
    echo "\n##### Gathering and Compressing MoodleData directory. #####"
    if tar czf $DIRECTORY/mdBackup/$SITENAME-mdBackup_$DATETIME.tar.gz moodledata/; then
        echo "\n##### Successfully archived to $DIRECTORY/mdBackup/$SITENAME-mdBackup_$DATETIME.tar.gz #####"
        return 0
    else
        echo "\n##### An error occured while creating archive $SITENAME-mdBackup_$DATETIME.tar.gz #####"
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
    tarMD
    sleep 5
    umountDirectory
else
    if mountDirectory; then
        tarMD
        sleep 5
        umountDirectory
    else
        echo "\n##### Backup process failed! Stopping script... #####"
        sleep 5
    fi
fi
CURDATETIME=`date +%Y%m%d-%H%M`
echo "\n########################################"
echo "##### MDbackup ended $CURDATETIME #####"
echo "########################################\n\n"


