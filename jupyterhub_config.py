c = get_config()

import os

keyfile = '/ssl/ssl.key'
certfile = '/ssl/ssl.crt'
if os.path.exists(keyfile) and os.path.exists(certfile):
    c.JupyterHub.ssl_key = keyfile
    c.JupyterHub.ssl_cert = certfile
    c.JupyterHub.port = 443

c.LocalAuthenticator.create_system_users = True

c.Spawner.env_keep.extend([name for name in os.environ.get('ENVPASSWHITELIST','').split(',')])


c.JupyterHub.db_url = 'postgresql://postgres:{password}@{host}/{db}'.format(
    host=os.environ['POSTGRES_HOST'],
    password=os.environ['POSTGRES_PASSWORD'],
    db=os.environ['POSTGRES_DB'],
)
