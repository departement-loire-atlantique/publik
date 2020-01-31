# To pass env vars to Python scripts run by Publik in services which remove custom env vars:
# https://unix.stackexchange.com/questions/44370/how-to-make-unix-service-see-environment-variables
# So we hardcode the values in the file below when the container starts
import sys
sys.path.insert(0, "/home")
from pyenv import *

# Databases
# w.c.s. doesn't use Django ORM (yet) so do not declare any database for now.
#DATABASES['default']['ENGINE'] = 'tenant_schemas.postgresql_backend'
#DATABASES['default']['NAME'] = 'wcs'
#DATABASES['default']['USER'] = 'wcs'
#DATABASES['default']['PASSWORD'] = DB_WCS_PASS
#DATABASES['default']['HOST'] = 'db'
#DATABASES['default']['PORT'] = DB_PORT

# Zone
LANGUAGE_CODE = 'fr-fr'
TIME_ZONE = 'Europe/Paris'

LOGGING = LOGGING_FROM_PYENV

# Email configuration
# EMAIL_SUBJECT_PREFIX = '[combo] '
# SERVER_EMAIL = 'root@combo.example.org'
# DEFAULT_FROM_EMAIL = 'webmaster@combo.example.org'

# SMTP configuration
EMAIL_HOST = SMTP_HOST
EMAIL_HOST_USER = SMTP_USER
EMAIL_HOST_PASSWORD = SMTP_PASS
EMAIL_PORT = SMTP_PORT

# HTTPS Security
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_SECURE = True

