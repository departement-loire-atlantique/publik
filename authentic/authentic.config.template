# This file is called from `service`, which removes custom env vars:
# https://unix.stackexchange.com/questions/44370/how-to-make-unix-service-see-environment-variables
# So we hardcode the values when the container starts

DEBUG = bool('$DEBUG')

ALLOWED_HOSTS = '$ALLOWED_HOSTS'
if ALLOWED_HOSTS:
    ALLOWED_HOSTS = ALLOWED_HOSTS.split(';')
else:
    ALLOWED_HOSTS = []

# Databases
DATABASES['default']['NAME'] = 'authentic'
DATABASES['default']['USER'] = 'authentic'
DATABASES['default']['PASSWORD'] = '$DB_AUTHENTIC_PASS'
DATABASES['default']['HOST'] = 'db'
DATABASES['default']['PORT'] = '$DB_PORT'

BROKER_URL = 'amqp://{user}:{password}@rabbitmq:{port}//'.format(
    user='$RABBITMQ_DEFAULT_USER',
    password='$RABBITMQ_DEFAULT_PASS',
    port='$RABBITMQ_PORT',
)

# Zone
LANGUAGE_CODE = 'fr-fr'
TIME_ZONE = 'Europe/Paris'

# Email configuration
ADMINS = (
  ('$ERROR_MAIL_AUTHOR', '$ERROR_MAIL_ADDR'),
)
EMAIL_SUBJECT_PREFIX = '[authentic] '
SERVER_EMAIL = '$ERROR_MAIL_ADDR'
DEFAULT_FROM_EMAIL = '$ERROR_MAIL_ADDR'

# SMTP configuration
EMAIL_HOST = 'smtp'
#EMAIL_HOST_USER = ''
#EMAIL_HOST_PASSWORD = ''
EMAIL_PORT = '$MAILCATCHER_SMTP_PORT'

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



