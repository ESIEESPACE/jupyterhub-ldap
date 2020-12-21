#!/bin/bash
cat > /etc/nsswitch.conf << END
passwd:         files ldap
group:          files ldap
shadow:         files ldap
gshadow:        files 

hosts:          files dns
networks:       files

protocols:      db files
services:       db files
ethers:         db files
rpc:            db files

netgroup:       nis
END

sed 's/\<use_authtok\>//g' /etc/pam.d/common-password > /etc/pam.d/common-password

echo "session optional pam_mkhomedir.so skel=/etc/skel umask=077" >> /etc/pam.d/common-session

auth-client-config -t nss -p lac_ldap

cat > /usr/share/pam-configs/my_mkhomedir << END
Name: activate mkhomedir
Default: yes
Priority: 900
Session-Type: Additional
Session:
        required                        pam_mkhomedir.so umask=0022 skel=/etc/skel
END

pam-auth-update