#!/bin/bash
export CONF=/etc/ldap.conf

if [ "$BASE" ]; then 
  sed -i "/^base.*$/d" $CONF
  echo "base $BASE" >> $CONF 
fi

if [ "$URI" ]; then
  sed -i "/^uri.*$/d" $CONF
  echo "uri $URI" >> $CONF
fi

if [ "$BINDDN" ]; then
  sed -i "/^binddn.*$/d" $CONF
  echo "binddn $BINDDN" >> $CONF
fi

if [ "$BINDPW" ]; then
  sed -i "/^bindpw.*$/d" $CONF
  echo "bindpw $BINDPW" >> $CONF
fi

cat >> $CONF << END
pam_password crypt
END

if [ "$AD" ]; then
    cat >> $CONF << END 
nss_map_objectclass posixAccount user
nss_map_objectclass shadowAccount user
nss_map_attribute uid sAMAccountName
nss_map_attribute homeDirectory unixHomeDirectory
nss_map_attribute shadowLastChange pwdLastSet
nss_map_objectclass posixGroup group
nss_map_attribute uniqueMember member
pam_login_attribute sAMAccountName
pam_filter objectclass=User
pam_password ad
END

fi
chmod 777 /home
jupyterhub -f /srv/jupyterhub/jupyterhub_config.py --no-ssl
