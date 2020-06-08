#!/bin/bash

DATETIME=`date +%Y%m%d-%H%M`
DIRECTORY=/mnt/moodle.bak
DB=moodle

showinfo(){
    echo "\n\n########################################"
    echo "##### DBbackup start $DATETIME #####"
    echo "########################################\n"
    echo "This script will perform the following steps to backup your $DB database:"
    echo "\t- Mount a backup space at $DIRECTORY."
    echo "\t- Perfom a mysqldump on the $DB database; with date and time as part of the file name."
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

dumpDB(){
    #create the dbBackup directory if missing
    mkdir -p $DIRECTORY/dbBackup
    echo "\n##### Dumping database. #####"
    if mysqldump -C -Q -e --create-options $DB > $DIRECTORY/dbBackup/$DB-dbBackup_$DATETIME.sql; then
        echo "\n##### Database successfully dumped to $DIRECTORY/dbBackup/$DB-dbBackup_$DATETIME.sql #####"
        return 0
    else
        echo "\n##### An error occured while dumping to $DIRECTORY/dbBackup/$DB-dbBackup_$DATETIME.sql #####"
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
    dumpDB
    sleep 5
    umountDirectory
else
    if mountDirectory; then
        dumpDB
        sleep 5
        umountDirectory
    else
        echo "\n##### Backup process failed! Stopping script... #####"
        sleep 5
fi
CURDATETIME=`date +%Y%m%d-%H%M`
echo "\n########################################"
echo "##### DBbackup ended $CURDATETIME #####"
echo "########################################\n\n"


