# Budoman-backend

## About project

Budoman-backend is a backend app for construction shop.
This is developed using:

- [Ruby](https://ruby-doc.org/3.1.1/) (3.1.1)
- [Rails](https://guides.rubyonrails.org/) (7.1.2)
- [PostgreSQL](https://www.postgresql.org/) (14.0.0)
- [Graphql](https://graphql-ruby.org/) (2.1.0)
- [RSpec](https://rspec.info/documentation/) (6.0.3)

## Requirements

- Ruby 3.1.1
- PostgreSQL 14

## Local development (Docker)

Docker is used only for local development (`Dockerfile.dev`, `RAILS_ENV=development`).

1. Make sure that you have filled `.env` file
2. Make sure that you have Docker installed on your local machine
3. Make sure that you have generated ssh keys with default path
4. Run the following commands to start the application

```bash
SSH_PUB_KEY=$(cat ~/.ssh/id_ed25519.pub) docker-compose build --no-cache
docker-compose up
```

App should be available on port 3333.

5. Follow [guide](docs/environment-setup/stripe.md) to configure the Stripe payment gateway locally

## Code quality

```bash
bundle exec rubocop # to turn on linter
bundle exec rspec # to turn on unit tests
bundle-audit check --update # to turn on bundle audit
```

## Tips

To turn on debugger inside container:

```bash
binding.pry # to stop performing app
docker attach budoman-backend-app # To have access to container's session
```

## Deploy

Production deploy runs on [Railway](https://railway.com) using [Railpack](https://docs.railway.com/reference/config-as-code#specify-the-builder) (no Docker).

### Services

| Service | Start command |
| --- | --- |
| Web | `bundle exec puma -C config/puma.rb` |
| Worker | `bundle exec sidekiq` |

Add PostgreSQL and Redis plugins in the Railway project. Set the service builder to **Railpack**.

### Environment variables

Required:

- `RAILS_ENV=production`
- `RAILS_MASTER_KEY` — from local `config/master.key`
- `RAILS_LOG_TO_STDOUT=true`
- `DATABASE_URL` — from the PostgreSQL plugin (`${{Postgres.DATABASE_URL}}`)
- `REDIS_URL` — from the Redis plugin (`${{Redis.REDIS_URL}}`)

See `.env.sample` for the remaining application variables (AWS, Stripe, SMTP, Rollbar, Sidekiq panel).

### Migrations

Set pre-deploy command on the web service:

```bash
bundle exec rails db:prepare
```

