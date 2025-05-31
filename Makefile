all:	build up

build:
	docker compose build

up:
	docker network create hvac
	docker compose up -d hvac_grapher nginx db

down:
	docker compose down hvac_grapher nginx db
	docker network rm hvac

sh:
	docker exec -it hvac_grapher /bin/bash
	