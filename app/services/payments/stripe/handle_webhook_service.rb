# frozen_string_literal: true

module Payments
  module Stripe
    class HandleWebhookService
      include ServiceStatus

      def initialize(event:)
        @event = event
      end

      def call
        case @event.type
        when 'checkout.session.completed'
          handle_checkout_session_completed
        when 'checkout.session.expired'
          handle_checkout_session_expired
        else
          handle_error('Unsupported event type!')
        end
      rescue StandardError => e
        handle_error(e.message)
      end

      private

      attr_reader :event

      def handle_checkout_session_completed
        payment = find_payment
        order = payment.order

        response = create_invoice_in_infakt(order)
        return if errors.any?

        ActiveRecord::Base.transaction do
          status = Payment::STRIPE_STATUS_MAPPING.fetch(session.payment_status)
          payment.update!(status: status)
          Invoice.create!(order:, provider_name: Invoice::INFAKT_PROVIDER, external_uuid: response['uuid'])
        end

        send_order_created_email(order)
      end

      def create_invoice_in_infakt(order)
        service = Invoices::Infakt::CreateInvoiceService.new(order:)
        response = service.call
        return response if service.success?

        handle_error(service.errors.join(', '))
      end

      def send_order_created_email(order)
        OrderMailer.with(order: order).order_created.deliver_later(queue: :order)
      end

      def handle_checkout_session_expired
        find_payment.expired!
      end

      def find_payment
        Payment.where(provider: 'stripe').find_by!("provider_data ->> ? = ?", 'checkout_session_id', session.id)
      end

      def session
        event.data.object
      end

      def handle_error(message)
        errors << message
        nil
      end
    end
  end
end
