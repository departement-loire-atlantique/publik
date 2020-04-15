# WARNING: this file is NOT a shell script but a config file
# Then quotes are part of the value for docker-compose
# e.g.: MYVAR="aaa" will give "aaa" (with the quotes) and not aaa

#
# VARIABLES BELOW MUST HAVE A NON-EMPTY VALUE
#

export ERROR_MAIL_ADDR=

# DOMAIN : A publik module URL format is {*_SUBDOMAIN}{ENV}.{DOMAIN}
export DOMAIN=
export ENV=

# Main administrator email
export EMAIL=

export ERROR_MAIL_AUTHOR=Support technique Publik

export RABBITMQ_DEFAULT_USER=hobo

export AUTHENTIC_SUBDOMAIN=auth
export COMBO_ADMIN_SUBDOMAIN=agents
export FARGO_SUBDOMAIN=documents
export HOBO_SUBDOMAIN=hobo
export PASSERELLE_SUBDOMAIN=passerelle
export WCS_SUBDOMAIN=demarches

export LOG_LEVEL=INFO

# 'console' or 'file'
# 'file' logs are available into /var/log/appname/django.log
# 'console' logs are available into systemd
export LOG_CHANNEL=console

#
# VARIABLES BELOW MUST BE DEFINED BUT CAN BE EMPTY
#

export DEBUG=1
# Empty means "debug mode disabled"
# DEBUG=



# WARNING: ALLOWED_HOSTS must be correct in production!
# See https://docs.djangoproject.com/en/2.2/ref/settings/#allowed-hosts
# Must be a semicolon-separated list of strings, e.g.: "localhost;127.0.0.1"
# An empty variable will produce Django's default (an empty list)
export ALLOWED_HOSTS=*

export SMTP_USER=

# WARNING: this file is NOT a shell script but a config file
# Then quotes are part of the value for docker-compose
# e.g.: MYVAR="aaa" will give "aaa" (with the quotes) and not aaa

#
# VARIABLES BELOW MUST HAVE A NON-EMPTY VALUE
#

export POSTGRES_PASSWORD=dochangeme

export DB_AUTHENTIC_PASS=dochangeme
export DB_COMBO_PASS=dochangeme
export DB_FARGO_PASS=dochangeme
export DB_HOBO_PASS=dochangeme
export DB_PASSERELLE_PASS=dochangeme
export DB_WCS_PASS=dochangeme

export RABBITMQ_DEFAULT_PASS=dochangeme

export SUPERUSER_PASS=dochangeme

#
# VARIABLES BELOW CAN HAVE AN EMPTY VALUE
#

export SMTP_PASS=
