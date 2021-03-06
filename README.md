# bash-backup-script

This bash script is written to help performing a full backup for linux systems.

> **NOTE: As this is an alpha build, data loss is not guaranteed. Make sure you backup your files before running the script. (Yeah it's quite ironic)**

## How to add it to your system:

### Via git:

Clone from repo:

`git clone https://github.com/dandycheng/bash-backup-script.git`

### Via CURL:

`curl https://raw.githubusercontent.com/dandycheng/bash-backup-script/master/backup-script.sh --output backup-script.sh`


## After downloading

*Do it based on your own preference or...*

**Move to home directory:**

`mv ./backup-script.sh ~`

**Followed by the command below to remove the empty folder:**

`cd .. && rm -rf bash-backup-script`

**Add bash alias:**

`echo 'alias backup="bash ~/backup-script.sh"' >> .bash_aliases && bash`


## Known bugs:

  - Unable to perform backups on folders with spaces (Causes data loss)
  
## Future implementations:
  
  - Integrity check for each compression
  - Multilevel compression
  - Better UX
