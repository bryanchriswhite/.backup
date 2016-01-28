#!/bin/bash

#######################################################################################
### See the documentation for more info: https://github.com/bryanchriswhite/.backup ###
#######################################################################################

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

### Load config file containing vars

. $PWD/.config


### Create temp directory

TEMP_DIR=`mktemp -d /tmp/.backup.XXXX`


### Tar, xz compress, and asymmetricly encrypt files

for ASYM_INPUT in $ASYM_INPUTS
do
  BASENAME=`basename $ASYM_INPUT`
  DIRNAME=`dirname $ASYM_INPUT`
  cd $DIRNAME
	tar -cJ $BASENAME 2>/dev/null | gpg -er $RECIPIENTS -o $TEMP_DIR/$BASENAME.txz.gpg
done


### Tar, xz compress, and symmetricly encrypt files

for SYM_INPUT in $SYM_INPUTS
do
  BASENAME=`basename $SYM_INPUT`
  DIRNAME=`dirname $SYM_INPUT`
  cd $DIRNAME
  read -sp "Enter passphrase for $SYM_INPUT: " PASSPHRASE
  echo
  cd $DIRNAME
  tar -cJ $BASENAME 2>/dev/null | gpg --passphrase $PASSPHRASE -c -o $TEMP_DIR/$BASENAME.txz.gpg
done


### cd to temp directory for clean tarball

cd $TEMP_DIR


### Create final tarball of encrypted files

tar -cvf $BACKUP_OUTPUT_DIR/$BACKUP_OUTPUT_FILE .*.gpg
chmod 600 $BACKUP_OUTPUT_DIR/$BACKUP_OUTPUT_FILE


### Cleanup temp directory

rm -rf $TEMP_DIR
