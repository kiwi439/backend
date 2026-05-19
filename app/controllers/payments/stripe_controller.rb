# frozen_string_literal: true

module Payments
  class StripeController < ApplicationController
    def update_status
      event = verify_event
      service = Payments::Stripe::HandleWebhookService.new(event: event)
      service.call
      return head :ok if service.success?

      handle_error(service.errors.join(', '))
    rescue StandardError => e
      handle_error(e)
    end

    private

    def verify_event
      payload = request.raw_post
      signature = request.headers['Stripe-Signature']
      ::Stripe::Webhook.construct_event(payload, signature, ENV.fetch('STRIPE_WEBHOOK_SIGNING_SECRET'))
    end

    def handle_error(error)
      Rollbar.error(error)
      head :unprocessable_entity
    end
  end
end
