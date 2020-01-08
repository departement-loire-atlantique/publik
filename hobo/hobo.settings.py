import os

DEBUG = bool(os.environ.get('DEBUG', False))

if os.environ.get('ALLOWED_HOSTS'):
    ALLOWED_HOSTS = os.environ['ALLOWED_HOSTS'].split(';')

# Databases
DATABASES['default']['NAME'] = 'hobo'
DATABASES['default']['USER'] = 'hobo'
DATABASES['default']['PASSWORD'] = os.environ['DB_HOBO_PASS']
DATABASES['default']['HOST'] = os.environ['DB_HOST']
DATABASES['default']['PORT'] = os.environ['DB_PORT']

BROKER_URL = 'amqp://{user}:{password}@{host}:{port}//'.format(
    user=os.environ['RABBITMQ_DEFAULT_USER'],
    password=os.environ['RABBITMQ_DEFAULT_PASS'],
    host=os.environ['RABBITMQ_HOST'],
    port=os.environ['RABBITMQ_PORT'],
)

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



