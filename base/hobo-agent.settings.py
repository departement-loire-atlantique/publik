import os

# AMQP message broker
# http://celery.readthedocs.org/en/latest/configuration.html#broker-url
# transport://userid:password@hostname:port/virtual_host
BROKER_URL = 'amqp://{user}:{password}@{host}:{port}//'.format(
    user=os.environ['RABBITMQ_DEFAULT_USER'],
    password=os.environ['RABBITMQ_DEFAULT_PASS'],
    host='rabbitmq',
    port=os.environ['RABBITMQ_PORT'],
)
