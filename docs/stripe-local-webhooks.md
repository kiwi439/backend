# Stripe: local payment gateway and webhooks

The backend handles Stripe webhooks in `Payments::StripeController#update_status` (`POST /payments/stripe/update_status`). Configure Stripe to send only events that the handler supports:

- `checkout.session.completed`
- `checkout.session.expired`

Other event types will fail in the handler.

## Requirements

- [Stripe CLI](https://stripe.com/docs/stripe-cli) authenticated to your test account (`stripe login`)
- Backend running (default port **3333**; see `README.md`)

## Environment variables

In `.env` (see `.env.sample`):

- `STRIPE_SECRET_KEY` — secret key from [Stripe Dashboard](https://dashboard.stripe.com/test/apikeys) (test mode)
- `STRIPE_WEBHOOK_SIGNING_SECRET` — signing secret for webhook verification (see below)

## Listening and forwarding events to the local backend

1. Start the backend so it is reachable at the host and port you use below (e.g. `http://localhost:3333`).

2. In another terminal, run Stripe CLI with the same event list as the handler:

```bash
stripe listen \
  --events checkout.session.completed,checkout.session.expired \
  --forward-to localhost:3333/payments/stripe/update_status
```

3. The `stripe listen` output prints a **Webhook signing secret** (`whsec_...`). Put it in `STRIPE_WEBHOOK_SIGNING_SECRET` in `.env` and restart the server so the variable is loaded.

Without a correct `STRIPE_WEBHOOK_SIGNING_SECRET`, `Stripe::Webhook.construct_event` will fail and the endpoint will return an error.

## Triggering synthetic events

You can send synthetic events (the payload may not match rows in your local database—useful mainly to verify signing and routing):

```bash
stripe trigger checkout.session.completed
stripe trigger checkout.session.expired
```

## Related files

- `app/controllers/payments/stripe_controller.rb` — signature verification and `handle_event`
- `config/routes.rb` — route `POST /payments/stripe/update_status`
