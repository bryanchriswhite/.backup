#!/bin/bash

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

### Load config file containing vars

. $PWD/.config


TEMP_DIR=`mktemp -d /tmp/.backup.XXXX`
cd $TEMP_DIR


### Asymmetricly encrypted files

for ASYM_INPUT in $ASYM_INPUTS
do
	tar -cvJ $HOME/$ASYM_INPUT 2>/dev/null | gpg -er bryanchriswhite@gmail.com -o $TEMP_DIR/$ASYM_INPUT.txz.gpg
done


### Symmetricly encrypted files

for SYM_INPUT in $SYM_INPUTS
do
  read -sp "Enter passphrase for $SYM_INPUT: " PASSPHRASE
  echo
  tar -cvJ $HOME/$SYM_INPUT 2>/dev/null | gpg --passphrase $PASSPHRASE -c -o $TEMP_DIR/$SYM_INPUT.txz.gpg
done

tar -cvf $BACKUP_DIR/.keys_backup.tar .*.gpg
chmod 600 $BACKUP_DIR/.keys_backup.tar

rm -rf $TEMP_DIR
