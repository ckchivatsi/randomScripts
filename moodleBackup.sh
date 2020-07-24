#!/bin/bash

DATETIME=`date +%Y%m%d-%H%M`
DIRECTORY=/mnt/moodle.bak
DB=moodle
SITENAME=JAM-VLE
mdDIRECTORY=/opt/moodledata
# $mdDIRECTORY is a cache folder of the /var/moodledata directory
# It get updated using RSYNC before the backup process starts
# This reduces the chance of backup failure due to files being used or updated during the archiving process

showinfo(){
    echo "\n\n############################################"
    echo "##### MoodleBackup start $DATETIME #####"
    echo "############################################\n"
    echo "This script will perform the following steps to backup your Moodle database and data:"
    echo "\t- Mount a backup space at $DIRECTORY."
    echo "\t- Perfom a mysqldump on the $DB database; append datetime stamp to file name."
    echo "\t- Archive the moodledata directory to $DIRECTORY/mdBackup/; append datetime stamp to file name."
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

dumpDB(){
    #create the dbBackup directory if missing
    mkdir -p $DIRECTORY/dbBackup
    echo "\n##### Dumping database. #####"
    if mysqldump -C -Q -e --create-options $DB > $DIRECTORY/dbBackup/$DB-dbBackup_$DATETIME.sql; then
        echo "\n##### `date +%Y%m%d-%H%M` : Database successfully dumped to $DIRECTORY/dbBackup/$DB-dbBackup_$DATETIME.sql #####"
        return 0
    else
        echo "\n##### `date +%Y%m%d-%H%M` : An error occured while dumping to $DIRECTORY/dbBackup/$DB-dbBackup_$DATETIME.sql #####"
        return 1
    fi
}

tarMD(){
    #create the mdBackup directory if missing
    mkdir -p $DIRECTORY/mdBackup
    cd $mdDIRECTORY/..
    echo "\n##### Gathering and Compressing MoodleData directory. #####"
    if tar czf $DIRECTORY/mdBackup/$SITENAME-mdBackup_$DATETIME.tar.gz moodledata/; then
        echo "\n##### `date +%Y%m%d-%H%M` : Successfully archived to $DIRECTORY/mdBackup/$SITENAME-mdBackup_$DATETIME.tar.gz #####"
        return 0
    else
        echo "\n##### `date +%Y%m%d-%H%M` : An error occured while creating archive $SITENAME-mdBackup_$DATETIME.tar.gz #####"
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
    dumpDB
    sleep 5
    tarMD
    sleep 5
    umountDirectory
else
    if mountDirectory; then
        dumpDB
        sleep 5
        tarMD
        sleep 5
        umountDirectory
    else
        echo "\n##### `date +%Y%m%d-%H%M` : Backup process failed! Stopping script... #####"
        sleep 5
    fi
fi

echo "\n############################################"
echo "##### MoodleBackup ended `date +%Y%m%d-%H%M` #####"
echo "############################################\n\n"


