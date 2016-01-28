.backup
=======

Rationale
---------
This utility is designed to genarate a compressed, secure, single-file backup of highly sensitive data, e.g. encryption keys, api keys, etc.

This is done by using a combination of [tar](https://en.wikipedia.org/wiki/Tar_(computing)) (with **and** without [xz](https://en.wikipedia.org/wiki/Xz) compression) 
and [GPG](https://en.wikipedia.org/wiki/GNU_Privacy_Guard).


Methodology
---------
1. For each discrete directory and/or file, generate an xz compressed tarball
1. GPG encrypt aforementioned tarball; you may choose to encrypt each discrete tarball one of two ways:
  * **Asymetrically**: You may choose which GPG recipients (via email or key ID) may decrypt **all** discrete tarballs
  * **Symmetrically**: You may choose a passphrase for **each** discrete tarball
1. All discrete tarballs are `tar`'d into a single (uncompressed) tarball
1. Final tarball is `chmod`'d to `0600` and is ready to be safely stored wherever


Setup
-----
1. Clone the git repo where you want to run the tool from (e.g. `~/.backup`)
 
 ```bash
 git clone git@github.com/bryanchriswhite/.backup ~/.backup ## Replace "~/.backup" with the desired destination (optional)
 cd !!:3 ## Change directory to the destination (for subsequent steps [optional])
 ```
1. Copy the `.config.example` file to `.config`
 
 ```bash
 cp .config.example .config
 ```
1. Modify the newly created `.config` file's variables to suite your requirements; see the [configure](#configure) section below


Configure
---------
The `.config` file contains the following variables:

| Variable Name | Purpose | Example |
|---------------|---------|---------|
| `BACKUP_DIR` | Destination where final tarball will be output (_NOTE: must **not** have a trailing `/`_) | `$HOME/.backup` |
| `RECIPIENTS` | Space delimited list of email addresses or GPG key IDs to be used for **all** asymmetric encryption of discrete tarballs | `bryanchriswhite@gmail.com` |
| `ASYM_INPUTS` | Newline delimited list of all discrete directories/files to be `tar`'d, compressed, and **asymmetrically** encrypted in [step 1](#methodology) _(such that `RECIPIENTS` are able to decrypt them)_ | _[see `.config.example`](https://github.com/bryanchriswhite/.backup/blob/master/.config.example#L14) - (markdown tables don't allow explicit multi-line cells)_ |
| `SYM_INPUTS` | Newline delimited list of all discrete directories/files to be `tar`'d, compressed, and **symmetrically** encrypted in [step 1](#methodology) using a passphrase; _(you will be prompted to enter a passphrase for each discrete directory/file [i.e. line in this multi-line variable])_ | _[see `.config.example`](https://github.com/bryanchriswhite/.backup/blob/master/.config.example#L23) - (markdown tables don't allow explicit multi-line cells)_ |
