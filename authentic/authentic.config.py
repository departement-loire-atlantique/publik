import os

DEBUG = bool(os.environ.get('DEBUG', False))

if os.environ.get('ALLOWED_HOSTS'):
    ALLOWED_HOSTS = os.environ['ALLOWED_HOSTS'].split(';')

# Databases
DATABASES['default']['NAME'] = 'authentic'
DATABASES['default']['USER'] = 'authentic'
DATABASES['default']['PASSWORD'] = os.environ['DB_AUTHENTIC_PASS']
DATABASES['default']['HOST'] = os.environ['DB_HOST']
DATABASES['default']['PORT'] = os.environ['DB_PORT']

BROKER_URL = 'amqp://{user}:{password}@rabbitmq:{port}//'.format(
    user=os.environ['RABBITMQ_USER'],
    password=os.environ['RABBITMQ_PASS'],
    port=os.environ['RABBITMQ_PORT'],
)

# Zone
LANGUAGE_CODE = 'fr-fr'
TIME_ZONE = 'Europe/Paris'

# Email configuration
ADMINS = (
  (os.environ['ERROR_MAIL_AUTHOR'], os.environ['ERROR_MAIL_ADDR']),
)
EMAIL_SUBJECT_PREFIX = '[authentic] '
SERVER_EMAIL = os.environ['ERROR_MAIL_ADDR']
DEFAULT_FROM_EMAIL = os.environ['ERROR_MAIL_ADDR']

# SMTP configuration
EMAIL_HOST = 'smtp'
#EMAIL_HOST_USER = ''
#EMAIL_HOST_PASSWORD = ''
EMAIL_PORT = os.environ['MAILCATCHER_SMTP_PORT']

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
    'filters': {
        'require_debug_false': {
            '()': 'django.utils.log.RequireDebugFalse',
        },
        'require_debug_true': {
            '()': 'django.utils.log.RequireDebugTrue',
        },
    },
    'formatters': {
        'simple': {
            'format': '[%(asctime)s] %(name)s %(levelname)s %(message)s',
            'datefmt': '%d/%b/%Y %H:%M:%S'
        },
    },
    'handlers': {
        'console': {
            'level': 'DEBUG',
            'filters': ['require_debug_true'],
            'class': 'logging.StreamHandler',
            'formatter': 'simple'
        },
    },
    'loggers': {
	'':{
            'handlers': ['console'],
            'level': 'INFO',
            'disabled': False
        },
    },
}



