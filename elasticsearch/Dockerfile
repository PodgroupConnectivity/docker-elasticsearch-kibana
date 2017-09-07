FROM elasticsearch:latest
MAINTAINER Jose Enrique Ruiz Navarro, quique.ruiz@podgroup.com
ENV ELASTICSEARCH_CONFIG /etc/elasticsearch
COPY config/elasticsearch.yml ${ELASTICSEARCH_CONFIG}
COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh
RUN mkdir /usr/share/elasticsearch/data/backups
ENV PATH=$PATH:/usr/share/elasticsearch/bin/elasticsearch
ENV ES_JAVA_OPTS="-Des.path.conf=/etc/elasticsearch -Xms1g -Xmx1g"
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["elasticsearch"]
