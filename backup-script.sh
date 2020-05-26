#!/bin/bash
if [ $EUID -ne 0 ]; then
    echo "Please run this code as a root user to prevent pausing for required packages installations"
fi
currentDir=''

reqDir() {
    read -p "Change to the desired directory for backup: " CURRENT_DIR
}
reqDir

while [ ! -d $CURRENT_DIR ]; do
    echo The directory \"$CURRENT_DIR\" does not exist, please use a valid directory:
    echo
    reqDir
done

cd $CURRENT_DIR

folders=()
for folder in ./*/; do
    folders+=`echo "$folder<><> <><>on<><>"| tr ' ' '-' | tr '<><>' ' ' | tr -d './'`
done

nDirectories=`ls -ap | grep '/' | wc -l`

result=`dialog --stdout --hline "\Zb\Z1DO NOT CLOSE THE TERMINAL DURING BACKUP PROCESS\Zb\Z1" --colors --msgbox "Before starting the backup, take note:\n\n1. Make sure you have enough disk space to store the archive\n2. The archive will be in tar.gz format\n3. Files that are not in folders will be compressed with tar.gz format\n" 20 80 --clear --hline "\Zb\Z1DO NOT CLOSE THE TERMINAL DURING BACKUP PROCESS\Zb\Z1" --keep-window --colors --no-shadow --ok-label 'Start backup' --checklist "\ZbSelect directories to perform a backup\Zb" 0 80 $nDirectories ${folders[@]}`


echo Checking dependencies...
if [ ! -f /usr/bin/tree ]; then
    echo Installing package dependencies...
    sudo apt-get install tree  -y
fi
echo

backupFolder=`pwd | grep -Po '\w+$'`-backup-\($(date | tr ' ' '_')\)
mkdir .$backupFolder
if [ -f ./.backup-temp ]; then
    touch .backup-temp
else
    > .backup-temp
fi


for x in ${result[@]}; do
    if [[ ! $x=~"^\.?Desktop-backup"  ]]; then
        tree -iL 1 --noreport $x >> .backup-temp
    fi
done

for x in `cat ./.backup-temp`; do
    if [[ $x != ".backup-temp" ]]; then
        tar -zvf $x.tar.gz -c $x
        mv $x.tar.gz .$backupFolder
    fi
done

mv .$backupFolder $backupFolder