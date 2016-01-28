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
  * **Symmetrically**: 
