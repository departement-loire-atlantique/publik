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
DATABASES['default']['NAME'] = 'hobo'
DATABASES['default']['USER'] = 'hobo'
DATABASES['default']['PASSWORD'] = '$DB_HOBO_PASS'
DATABASES['default']['HOST'] = 'db'
DATABASES['default']['PORT'] = '$DB_PORT'

BROKER_URL = 'amqp://{user}:{password}@rabbitmq:{port}//'.format(
    user='$RABBITMQ_DEFAULT_USER',
    password='$RABBITMQ_DEFAULT_PASS',
    port='$RABBITMQ_PORT',
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



