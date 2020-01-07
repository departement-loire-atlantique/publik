# AMQP message broker
# http://celery.readthedocs.org/en/latest/configuration.html#broker-url
# transport://userid:password@hostname:port/virtual_host
BROKER_URL = 'amqp://{user}:{password}@rabbitmq:{port}//'.format(
    user=os.environ['RABBITMQ_USER'],
    password=os.environ['RABBITMQ_PASS'],
    port=os.environ['RABBITMQ_PORT'],
)
