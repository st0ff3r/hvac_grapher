# hvac_ _grapher

hvac_grapher

## Build details

make build

make up

To initialize db (only do it first time!):

docker cp hvac.sql hvac-db:/tmp/
docker cp hvac_setup_db.sh hvac-db:/tmp/
docker exec -it hvac-db /tmp/hvac_setup_db.sh
