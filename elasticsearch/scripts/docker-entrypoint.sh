#!/bin/bash

set -e

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- elasticsearch "$@"
fi

# Drop root privileges if we are running elasticsearch
# allow the container to be started with `--user`
if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
	# Change the ownership of user-mutable directories to elasticsearch
	for path in \
		/usr/share/elasticsearch/data \
		/usr/share/elasticsearch/logs \
	; do
		chown -R elasticsearch:elasticsearch "$path"
	done

	set -- gosu elasticsearch "$@"
	#exec gosu elasticsearch "$BASH_SOURCE" "$@"
fi

if [ -z "$ELASTICSEARCH_NAME" ]; then
        echo "Name will be random"
else
        sed -i -e "s/^#node.name: name/node.name: $ELASTICSEARCH_NAME/" $ELASTICSEARCH_CONFIG/elasticsearch.yml
fi

if [ -z "$ELASTICSEARCH_BIND_ADDRESS" ]; then
        echo "Localhost bind"
else
        sed -i -e "s/^#network.host: 0.0.0.0/network.host: $ELASTICSEARCH_BIND_ADDRESS/" $ELASTICSEARCH_CONFIG/elasticsearch.yml
fi

if [ -z "$ELASTICSEARCH_CLUSTER" ]; then
        echo "No cluster"
else
	IPS='[ '
	IFS=',' read -ra IP <<< "$ELASTICSEARCH_CLUSTER"
	for i in "${IP[@]}"; do
		IPS=$IPS\"$i\",
	done
  IPS=$IPS" ]"
  echo $IPS
  sed -i -e "s/^#discovery.zen.ping.unicast.hosts: host/discovery.zen.ping.unicast.hosts: $IPS/" $ELASTICSEARCH_CONFIG/elasticsearch.yml
fi



# As argument is not related to elasticsearch,
# then assume that user wants to run his own process,
# for example a `bash` shell to explore this image
exec "$@"
