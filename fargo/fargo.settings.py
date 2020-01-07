import os

DEBUG = bool(os.environ.get('DEBUG', False))

if os.environ.get('ALLOWED_HOSTS'):
    ALLOWED_HOSTS = os.environ['ALLOWED_HOSTS'].split(';')

# Databases
DATABASES['default']['NAME'] = 'fargo'
DATABASES['default']['USER'] = 'fargo'
DATABASES['default']['PASSWORD'] = os.environ['DB_FARGO_PASS']
DATABASES['default']['HOST'] = os.environ['DB_HOST']
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



