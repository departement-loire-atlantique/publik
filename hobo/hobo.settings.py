# To pass env vars to Python scripts run by Publik in services which remove custom env vars:
# https://unix.stackexchange.com/questions/44370/how-to-make-unix-service-see-environment-variables
# So we hardcode the values in the file below when the container starts
import sys
sys.path.insert(0, "/home")
from pyenv import *

# Databases
DATABASES['default']['ENGINE'] = 'tenant_schemas.postgresql_backend'
DATABASES['default']['NAME'] = 'hobo'
DATABASES['default']['USER'] = 'hobo'
DATABASES['default']['PASSWORD'] = DB_HOBO_PASS
DATABASES['default']['HOST'] = 'db'
DATABASES['default']['PORT'] = DB_PORT

BROKER_URL = 'amqp://{user}:{password}@rabbitmq:{port}//'.format(
    user=RABBITMQ_DEFAULT_USER,
    password=RABBITMQ_DEFAULT_PASS,
    port=RABBITMQ_PORT,
)

LANGUAGE_CODE = 'fr-fr'
TIME_ZONE = 'Europe/Paris'

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
            'filename': '/var/log/hobo/django.log',
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



