.PHONY:build
build:
	docker build .

.PHONY:up
up:
	docker-compose -p admin-api -f docker-compose.yml up --detach

.PHONY:down
down:
	docker-compose -p admin-api -f docker-compose.yml down