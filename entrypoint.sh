#!/bin/bash

echo "Waiting for database to be ready..."
until python3 manage.py showmigrations 2>/dev/null | head -1; do
  echo "Database not ready yet, retrying in 2s..."
  sleep 2
done

python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py collectstatic --noinput
python3 manage.py createhorillauser --first_name admin --last_name admin --username admin --password admin --email admin@example.com --phone 1234567890
gunicorn --bind 0.0.0.0:8010 horilla.wsgi:application
