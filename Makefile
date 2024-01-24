COMPOSE = docker compose -f docker-compose.dev.yml

ps:
	$(COMPOSE) ps
setup:
	$(MAKE) package
	$(COMPOSE) run --rm rails bundle exec rails db:create db:migrate db:seed
build:
	$(COMPOSE) build
package:
	$(COMPOSE) run --rm vuejs pnpm install
	$(COMPOSE) run --rm rails bundle install
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
bash-vuejs:
	$(COMPOSE) run --rm vuejs bash
bash-mysql:
	$(COMPOSE) run --rm mysql bash
console:
	$(COMPOSE) run --rm rails bundle exec rails c
purge:
	$(COMPOSE) down --remove-orphans --volumes --rmi all
