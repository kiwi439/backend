# Budoman-backend

Backend API for Budoman construction shop.

## Requirements

- Docker and Docker Compose
- `.env` file (see `.env.sample`)
- Generated SSH keys

## Local development

```bash
# To turn on application locally on port 3333
SSH_PUB_KEY=$(cat ~/.ssh/id_ed25519.pub) docker-compose build --no-cache
docker-compose up

# To work with payment gate locally
Follow guide backend/docs/environment-setup/stripe.md to configure the Stripe payment gateway locally.
```

## Code quality

```bash
bundle exec rubocop
bundle exec rspec
bundle-audit check --update
```

## Tips

To turn on debugger inside container:

```bash
binding.pry # to stop performing app
docker attach budoman-backend-app # To have access to container's session
```

## Deploy

Production is deployed manually on [Railway](https://railway.com).  Application is deployed manually and  configured in the Railway dashboard