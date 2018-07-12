#!/bin/bash
set -e

# Create all databases except WCS one which it is created when first started
psql -v ON_ERROR_STOP=1 <<-EOSQL
    CREATE USER hobo;
    CREATE DATABASE hobo TEMPLATE=template0 ENCODING 'UTF8' LC_COLLATE='fr_FR.UTF_8' LC_CTYPE='fr_FR.UTF-8';
    GRANT ALL PRIVILEGES ON DATABASE hobo TO hobo;
    ALTER USER hobo WITH PASSWORD 'hobopass';
    CREATE USER passerelle;
    CREATE DATABASE passerelle TEMPLATE=template0 LC_COLLATE='fr_FR.UTF_8' LC_CTYPE='fr_FR.UTF-8';
    GRANT ALL PRIVILEGES ON DATABASE passerelle TO passerelle;
    ALTER USER passerelle WITH PASSWORD 'passerellepass';
    CREATE USER combo;
    CREATE DATABASE combo TEMPLATE=template0 LC_COLLATE='fr_FR.UTF_8' LC_CTYPE='fr_FR.UTF-8';
    GRANT ALL PRIVILEGES ON DATABASE combo TO combo;
    ALTER USER combo WITH PASSWORD 'combopass';
    CREATE USER fargo;
    CREATE DATABASE fargo TEMPLATE=template0 LC_COLLATE='fr_FR.UTF_8' LC_CTYPE='fr_FR.UTF-8';
    GRANT ALL PRIVILEGES ON DATABASE fargo TO fargo;
    ALTER USER fargo WITH PASSWORD 'fargopass';
    CREATE USER wcs CREATEDB;
    ALTER USER wcs WITH PASSWORD 'wcspass';
    CREATE USER authentic;
    CREATE DATABASE authentic TEMPLATE=template0 LC_COLLATE='fr_FR.UTF_8' LC_CTYPE='fr_FR.UTF-8';
    GRANT ALL PRIVILEGES ON DATABASE authentic TO authentic;
    ALTER USER authentic WITH PASSWORD 'authenticpass';
EOSQL
