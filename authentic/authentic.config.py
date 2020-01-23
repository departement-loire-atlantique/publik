# To pass env vars to Python scripts run by Publik in services which remove custom env vars:
# https://unix.stackexchange.com/questions/44370/how-to-make-unix-service-see-environment-variables
# So we hardcode the values in the file below when the container starts
import sys
sys.path.insert(0, "/home")
from pyenv import *

# Databases
DATABASES['default']['ENGINE'] = 'tenant_schemas.postgresql_backend'
DATABASES['default']['NAME'] = 'authentic'
DATABASES['default']['USER'] = 'authentic'
DATABASES['default']['PASSWORD'] = DB_AUTHENTIC_PASS
DATABASES['default']['HOST'] = 'db'
DATABASES['default']['PORT'] = DB_PORT

BROKER_URL = 'amqp://{user}:{password}@rabbitmq:{port}//'.format(
    user=RABBITMQ_DEFAULT_USER,
    password=RABBITMQ_DEFAULT_PASS,
    port=RABBITMQ_PORT,
)

# Zone
LANGUAGE_CODE = 'fr-fr'
TIME_ZONE = 'Europe/Paris'

# Email configuration
ADMINS = (
  (ERROR_MAIL_AUTHOR, ERROR_MAIL_ADDR),
)
EMAIL_SUBJECT_PREFIX = '[authentic] '
SERVER_EMAIL = ERROR_MAIL_ADDR
DEFAULT_FROM_EMAIL = ERROR_MAIL_ADDR

# SMTP configuration
EMAIL_HOST = SMTP_HOST
EMAIL_HOST_USER = SMTP_USER
EMAIL_HOST_PASSWORD = SMTP_PASS
EMAIL_PORT = SMTP_PORT

# HTTPS Security
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_SECURE = True

# Idp
# SAML 2.0 IDP
#A2_IDP_SAML2_ENABLE = False
# CAS 1.0 / 2.0 IDP
#A2_IDP_CAS_ENABLE = False
# OpenID 1.0 / 2.0 IDP
#A2_IDP_OPENID_ENABLE = False

# Authentifications
#A2_AUTH_PASSWORD_ENABLE = True
#A2_SSLAUTH_ENABLE = False

CACHES = {
    'default': {
       'BACKEND': 'hobo.multitenant.cache.TenantCache',
       'REAL_BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
       'LOCATION': '127.0.0.1:11211',
   }
}

# Role provisionning via local RabbitMQ
HOBO_ROLE_EXPORT = True

LOGGING = {
    'version': 1,
    'disable_existing_loggers': True,
    'formatters': {
        'simple': {
            'format': '[%(asctime)s] %(name)s %(levelname)s %(message)s',
            'datefmt': '%d/%b/%Y %H:%M:%S'
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'simple'
        },
        'file': {
            'class': 'logging.FileHandler',
            'filename': '/var/log/authentic2-multitenant/django.log',
            'formatter': 'simple'
        },
    },
    'loggers': {
	'':{
            'handlers': ['console', 'file'],
            'level': LOG_LEVEL,
            'disabled': False
        },
    },
}



