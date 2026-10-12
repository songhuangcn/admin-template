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

# ---- autoteam 入口 ----
# check：对齐原 GitLab CI 的 test 阶段（standardrb、rspec、前端 lint），全部走 docker compose。
check:
	$(COMPOSE) build
	$(COMPOSE) up -d mysql
	$(COMPOSE) run --rm rails bash -c 'until mysqladmin ping -h"$$DATABASE_HOST" -uroot -p"$$DATABASE_PASSWORD" --silent; do sleep 2; done'
	$(COMPOSE) run --rm rails bundle exec standardrb
	$(COMPOSE) run --rm -e RAILS_ENV=test rails bash -c 'bundle exec rails db:create db:test:prepare && bundle exec rspec'
	$(COMPOSE) run --rm vuejs pnpm lint --max-warnings=0
	$(COMPOSE) down --remove-orphans
# dev：沿用现有开发环境，可重复执行。
dev:
	$(MAKE) setup
	$(MAKE) upd
# deploy：没有线上环境，构建 backend、frontend 的生产镜像（prod 目标，不推送）成功即视为「上线」。
deploy:
	docker build --target prod -t admin-template-backend:prod ./backend
	docker build --target prod -t admin-template-frontend:prod ./frontend
