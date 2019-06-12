![Screenshot](https://i.imgur.com/xoB5LCY.png)


# chkext4.sh

chkext4.sh is a shell script that
- unmounts the target ext4 filesystem,
- checks the target ext4 filesystem,
- remounts the target filesystem, and
- refreshes owner and group permissions


Usage: [sudo] [sh] ./chkext4.sh [options [parameters]]

Options:

-f|--filesystem, Filesystem to be checked I.E. -f /media/systst/filesystem-name

-b|--badblocks, Check all blocks for errors (this takes a long time!) I.E. -b

-h|--help, Print help (this dialog) I.E. -h

./chkext4.sh unmounts the target ext4 filesystem, checks it, remounts the filesystem, and refreshes owner and group permissions


2019-06-11: Initial release
