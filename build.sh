docker build -t my_elastic .
docker volume create --name mydata
docker run --rm -ti -p 9200:9200 -v mydata:/usr/share/elasticsearch/data my_elastic
