bash:
	docker compose run --rm web bash

test:
	docker compose run --rm app bash -c "bundle exec rspec"

start:
	docker compose up
