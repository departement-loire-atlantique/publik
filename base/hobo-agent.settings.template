import os

# AMQP message broker
# http://celery.readthedocs.org/en/latest/configuration.html#broker-url
# transport://userid:password@hostname:port/virtual_host
# Will be filled in `start.sh` scripts
BROKER_URL = 'amqp://{user}:{password}@rabbitmq:{port}//'.format(
    user='$RABBITMQ_DEFAULT_USER',
    password='$RABBITMQ_DEFAULT_PASS',
    port='$RABBITMQ_PORT',
)
