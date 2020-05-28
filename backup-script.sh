#!/bin/bash

isRoot(){
    return $EUID -ne 0
}

if [[ ! isRoot ]]; then
    echo -e "Please run this code as a root user to prevent pausing for required packages installations\n"
fi

initialDir=`echo $PWD`
currentDir=$1

reqDir() {
    read -p "Change to the desired directory for backup: " currentDir
}

while [[ ! -d $currentDir ]] || [[ $currentDir == "" ]]; do
    echo "The directory \"$currentDir\" does not exist, please use a valid directory"
    reqDir
done

cd $currentDir

# Replacing spaces with custom delimiters to prevent line break
folders=()
for folder in ./*/; do
    folders+=`echo "$folder<><> <><>on<><>"| tr ' ' '-' | tr '<><>' ' ' | tr -d './'`
done

nDirectories=`ls -ap | grep '/' | wc -l`

result=`dialog --stdout --hline "\Zb\Z1DO NOT CLOSE THE TERMINAL DURING BACKUP PROCESS\Zb\Z1" --colors --msgbox "Before starting the backup, take note:\n\n1. Make sure you have enough disk space to store the archive\n2. The archive will be in tar.gz format\n3. Files that are not in folders will be compressed with tar.gz format\n" 20 80 --clear --hline "\Zb\Z1DO NOT CLOSE THE TERMINAL DURING BACKUP PROCESS\Zb\Z1" --keep-window --colors --no-shadow --ok-label 'Start backup' --checklist "\ZbSelect directories to perform a backup\Zb" 0 80 $nDirectories ${folders[@]}`


echo Checking dependencies...
if [[ ! -f /usr/bin/tree ]]; then
    echo Installing package dependencies...
    sudo apt-get install tree  -y
fi
echo

date=`date | tr ' ' '_'`

backupFolder="backup_($datee)"
mkdir .$backupFolder

compressDirs(){
    for x in ${result[@]}; do
        if [[ $x != $backupLogFile ]]; then
            tar -cf - $x | xz -6e -k > $x.tar.xz
            mv $x.tar.xz .$backupFolder
        fi
    done
}

compressDirs

mv .$backupFolder $backupFolder
logDesc="This backup log shows the directory that has been backed up to $backupFolder.\n"
fileList=`echo -e "DIRECTORIES\n------------\n${result[@]}" | tr ' ' '\n'`

backupLogFile=backup_log_\($date\)
touch $backupLogFile
echo -e "$logDesc\n$fileList" > "$backupLogFile"
mv $backupLogFile -t $backupFolder

tar -cf - $backupFolder | xz -9e > $backupFolder.tar.xz

if [[ isRoot ]]; then
    chmod 777 $backupFolder.tar.xz
fi

if [[ $PWD != $initialDir ]]; then
    mv $backupFolder.tar.xz -t "$initialDir"
fi
rm -rf $backupFolder
cd "$initialDir"