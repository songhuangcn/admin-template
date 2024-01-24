COMPOSE = sudo docker compose -f docker-compose.prod.yml --env-file .dockerenv

ps:
	$(COMPOSE) ps
images:
	$(COMPOSE) images
up:
	$(COMPOSE) up --remove-orphans
upd:
	$(COMPOSE) up --remove-orphans -d
down:
	$(COMPOSE) down --remove-orphans
restart:
	$(MAKE) down
	$(MAKE) upd
logs:
	$(COMPOSE) logs -f
bash-rails:
	$(COMPOSE) run --rm rails bash
bash-nginx:
	$(COMPOSE) run --rm nginx bash
bash-mysql:
	$(COMPOSE) run --rm mysql bash
console:
	$(COMPOSE) run --rm rails bundle exec rails c
