# frozen_string_literal: true

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
        create_invoice(payment.order)
      when 'checkout.session.expired'
        payment = Payment.where(provider: 'stripe').find_by!("provider_data ->> ? = ?", 'checkout_session_id', session.id)
        payment.expired!
      else
        Rollbar.error('Unsupported event type!', event_type: event.type) # TODO: Custom Rollbar error
      end
    end

    def create_invoice(order)
      service = Invoices::Infakt::CreateInvoiceService.new(order:)
      response = service.call
      return Rollbar.error(service.errors) unless service.success? # TODO: Custom Rollbar error

      order.invoice.create!(provider_name: Invoice::INFAKT_PROVIDER_NAME, external_uuid: response['uuid'])
    end
  end
end
