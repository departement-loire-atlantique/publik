import os

DEBUG = bool(os.environ.get('DEBUG', False))

if os.environ.get('ALLOWED_HOSTS'):
    ALLOWED_HOSTS = os.environ['ALLOWED_HOSTS'].split(';')

# Databases
DATABASES['default']['NAME'] = 'wcs'
DATABASES['default']['USER'] = 'wcs'
DATABASES['default']['PASSWORD'] = os.environ['DB_WCS_PASS']
DATABASES['default']['HOST'] = 'db'
DATABASES['default']['PORT'] = os.environ['DB_PORT']

# Zone
LANGUAGE_CODE = 'fr-fr'
TIME_ZONE = 'Europe/Paris'

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

# Email configuration
# EMAIL_SUBJECT_PREFIX = '[combo] '
# SERVER_EMAIL = 'root@combo.example.org'
# DEFAULT_FROM_EMAIL = 'webmaster@combo.example.org'

# SMTP configuration
EMAIL_HOST = 'smtp'
# EMAIL_HOST_USER = ''
# EMAIL_HOST_PASSWORD = ''
EMAIL_PORT = os.environ['MAILCATCHER_SMTP_PORT']

# HTTPS Security
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_SECURE = True

