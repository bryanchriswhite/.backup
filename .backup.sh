#!/bin/bash

BACKUP_DIR=$HOME/.backup
TEMP_DIR=`mktemp -d /tmp/.backup.XXXX`
cd $TEMP_DIR


### Asymmetricly encrypted files

for ASYM_INPUT in .ssh .aws .password-store
do
	tar -cJ $HOME/$ASYM_INPUT >/dev/null 2>&1 | gpg -er bryanchriswhite@gmail.com -o $TEMP_DIR/$ASYM_INPUT.gpg
done


### Symmetricly encrypted files

for SYM_INPUT in .gnupg
do
  read -sp "Enter passphrase for $SYM_INPUT: " PASSPHRASE
  echo
  tar -cJ $HOME/$SYM_INPUT >/dev/null 2>&1 | gpg --passphrase $PASSPHRASE -c -o $TEMP_DIR/$SYM_INPUT.gpg
done

tar -cvf $BACKUP_DIR/.keys_backup.tar .*.gpg
chmod 600 $BACKUP_DIR/.keys_backup.tar

rm -rf $TEMP_DIR
