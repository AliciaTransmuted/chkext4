#!/bin/bash

function show_usage (){
    printf "\n"
    printf "Usage: [sudo] [sh] $0 [options [parameters]]\n"
    printf "\n"
    printf "Options:\n"
    printf " -f|--filesystem, Filesystem to be checked I.E. -f /media/$target_user/filesystem-name\n"
    printf " -b|--badblocks, Check all blocks for errors (this takes a long time!) I.E. -b\n"
    printf " -h|--help, Print help (this dialog) I.E. -h\n"
    printf "\n"
    printf "$0 unmounts the target ext4 filesystem, checks it, remounts the filesystem, and refreshes owner and group permissions\n"
    printf "\n"

return 0
}

bad_blocks="N"
target_filesystem="empty"
target_user=$USER

if [ -n "$SUDO_USER" ]; then
   target_user=$SUDO_USER
fi

while [ ! -z "$1" ]; do
  case "$1" in
     --filesystem|-f)
         shift
         if [ -n "$1" ]; then
            target_filesystem="$1"
         fi
         ;;
     --badblocks|-b)
         bad_blocks="Y"
         ;;
     --help|-h)
         show_usage
         exit 1
         ;;
     *)
        show_usage
        exit 1
        ;;
  esac
shift
done

if [ "${target_filesystem}" = "empty" ];then
   show_usage
   exit 1
fi

###
### Find /dev addresses for file systems to be checked
###

df -h > df.txt
test_var_x=$(grep "${target_filesystem}" df.txt)
var_target="${test_var_x%% *}"
rm -f "df.txt"

printf "\n"
printf "*** File system check ${target_filesystem} on ${var_target}\n"
printf "\n"

sudo umount "${target_filesystem}"

if [ "${bad_blocks}" = "Y" ];then
   sudo fsck.ext4 -cDfty -C 0 "${var_target}"
else
   sudo fsck.ext4 -fty -C 0 "${var_target}"
fi

sudo mount "${var_target}" "${target_filesystem}"

printf "\n"
printf "*** chown -R ${target_user}:${target_user} ${target_filesystem} on ${var_target}\n"
sudo chown -R "${target_user}":"${target_user}" "${target_filesystem}"

printf "\n"
printf "*** chmod -R 775 ${target_filesystem} on ${var_target}\n"
sudo chmod -R 775 "${target_filesystem}"

printf "\n"
printf "*** $0 done...\n"
printf "\n"
