#!/bin/bash
config=/etc/filebeat/filebeat.yml
env
echo 'Filebeat init process done. Ready for start up.'
echo "Using the following configuration:"
cat /etc/filebeat/filebeat.yml
exec "$@"
