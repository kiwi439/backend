# frozen_string_literal: true

# stripe listen --events checkout.session.completed,checkout.session.expired --forward-to localhost:3333/payments/stripe/update_status

module Payments
  class StripeController < ApplicationController
    def update_status
      event = verify_event
      handle_event(event)
      head :ok
    rescue StandardError => e
      Rollbar.error(e)
      head :unprocessable_entity
    end

    private

    def verify_event
      payload = request.raw_post
      signature = request.headers['Stripe-Signature']
      ::Stripe::Webhook.construct_event(payload, signature, ENV.fetch('STRIPE_WEBHOOK_SIGNING_SECRET'))
    end

    def handle_event(event)
      session = event.data.object

      case event.type
      when 'checkout.session.completed'
        payment = Payment.where(provider: 'stripe').find_by!("provider_data ->> ? = ?", 'checkout_session_id', session.id)
        status = Payment::STRIPE_STATUS_MAPPING.fetch(session.payment_status)
        payment.update!(status: status)
      when 'checkout.session.expired'
        payment = Payment.where(provider: 'stripe').find_by!("provider_data ->> ? = ?", 'checkout_session_id', session.id)
        payment.expired!
      else
        raise StandardError.new('Unsupported event type!')
      end
    end
  end
end
