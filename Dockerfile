
FROM jupyterhub/jupyterhub:latest

RUN apt update && \
    apt full-upgrade -y

RUN apt install nano -y
RUN apt install libnss-ldap libpam-ldap ldap-utils nscd  -y

RUN pip install jupyter dockerspawner jupyterhub-ldap-authenticator

ADD configure_ldap.sh /srv/jupyterhub/configure_ldap.sh
RUN /srv/jupyterhub/configure_ldap.sh

RUN chmod 777 /home
VOLUME /home

ADD jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py
EXPOSE 443


ADD startup.sh /srv/jupyterhub/startup.sh

CMD ["/srv/jupyterhub/startup.sh"]
