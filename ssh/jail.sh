#!/bin/bash
#
# setup ssh jail
#

# config
jail = '/home/jail'
cmds = ('bash','sh')
cmdu = ('ssh','scp','sftp','rssh')

# tools
apt-get install rssh
< /etc/rss.conf \
    sed '/^# chrootpath = .*/s@@chrootpath='${jail}'@' \
    > /etc/rss.conf
wget -O /sbin/l2chroot http://www.cyberciti.biz/files/lighttpd/l2chroot.txt
< /sbin/l2chroot \
    sed '/^BASE=/s@@BASE="'${jail}'"@' \
    > /sbin/l2chroot
chmod +x /sbin/l2chroot

# jail group
addgroup jail

# jail dir
mkdir -p ${jail}/{dev,etc,lib,lib64,usr,bin,home}
mkdir -p ${jail}/usr/{bin,lib}
mkdir -p ${jail}/usr/lib/{openssh,rssh}
chown root:root ${jail}
chmod go-w ${jail}
mknod -m 666 ${jail}/dev/null c 1 3
cp -avr /etc/ld.so.cache.d ${jail}/etc/
cp /etc/ld.so.cache ${jail}/etc/
cp /etc/ld.so.conf ${jail}/etc/
cp /etc/nsswitch.conf ${jail}/etc/
cp /etc/resolv.conf ${jail}/etc/
cp /etc/hosts ${jail}/etc/
cp -r /lib/terminfo ${jail}/lib/

# sftp and rssh extra
for cmd in (openssh/sftp-server,rss/rssh_chroot_helper); do
    cp /usr/lib/${cmd} ${jail}/usr/lib/${cmd}
    l2chroot /usr/lib/${cmd}
done

# allow commands
for cmd in ${cmds}; do
    cp /bin/${cmd} ${jail}/bin/
    l2chroot /bin/${cmd}
done
for cmd in ${cmdu}; do
    cp /usr/bin/${cmd} ${jail}/usr/bin/
    l2chroot /usr/bin/${cmd}
done
