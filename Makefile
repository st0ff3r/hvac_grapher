all:	build up

build:
	docker compose build

up:
	docker network create hvac
	docker compose up -d hvac-grapher hvac-nginx hvac-db

down:
	docker compose down hvac-grapher hvac-nginx hvac-db
	docker network rm hvac

sh:
	docker exec -it hvac-grapher /bin/bash
	