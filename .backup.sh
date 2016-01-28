#!/bin/bash

#######################################################################################
### See the documentation for more info: https://github.com/bryanchriswhite/.backup ###
#######################################################################################

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

### Load config file containing vars

. $PWD/.config


### Create temp directory and make it cwd (needed for clean tarballs)

TEMP_DIR=`mktemp -d /tmp/.backup.XXXX`
cd $TEMP_DIR


### Tar, xz compress, and asymmetricly encrypt files

for ASYM_INPUT in $ASYM_INPUTS
do
	tar -cvJ $HOME/$ASYM_INPUT 2>/dev/null | gpg -er $RECIPIENTS -o $TEMP_DIR/$ASYM_INPUT.txz.gpg
done


### Tar, xz compress, and symmetricly encrypt files

for SYM_INPUT in $SYM_INPUTS
do
  read -sp "Enter passphrase for $SYM_INPUT: " PASSPHRASE
  echo
  tar -cvJ $HOME/$SYM_INPUT 2>/dev/null | gpg --passphrase $PASSPHRASE -c -o $TEMP_DIR/$SYM_INPUT.txz.gpg
done


### Create final tarball of encrypted files

tar -cvf $BACKUP_OUTPUT_DIR/$BACKUP_OUTPUT_FILE .*.gpg
chmod 600 $BACKUP_OUTPUT_DIR/$BACKUP_OUTPUT_FILE


### Cleanup temp directory

rm -rf $TEMP_DIR
