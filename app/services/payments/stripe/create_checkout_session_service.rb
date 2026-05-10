# frozen_string_literal: true

module Payments
  module Stripe
    class CreateCheckoutSessionService
      extend Utils::CallableObject

      PLN_TO_CENTS_MULTIPLIER = 100

      def initialize(order:)
        @order = order
      end

      def call
        line_items = []
        line_items += product_line_items
        line_items += delivery_line_item

        ::Stripe::Checkout::Session.create(
          mode: 'payment',
          payment_method_types: Payment::STRIPE_AVAILABLE_METHODS,
          line_items: line_items,
          success_url: "#{Rails.configuration.x.frontend_url}/thank-you-page?order_id=#{@order.id}",
          cancel_url: "#{Rails.configuration.x.frontend_url}/",
          metadata: { order_id: @order.id }
        )
      end

      private

      def product_line_items
        @order.products_orders.includes(:product).map do |product_order|
          product = product_order.product

          {
            quantity: product_order.product_quantity,
            price_data: {
              currency: 'pln',
              unit_amount: price_to_stripe_format(product.gross_price),
              product_data: { name: product.name }
            }
          }
        end
      end

      def delivery_line_item
        delivery_details = @order.delivery_details
        return [] if delivery_details.fetch(:price).to_d.zero?

        vat_multiplier = 1 + (BigDecimal(delivery_details.fetch(:vat_rate).to_s) / 100)
        netto_price = delivery_details.fetch(:price).to_d
        gross_price = (netto_price * vat_multiplier).round(2, :half_up)

        [
          {
            quantity: 1,
            price_data: {
              currency: 'pln',
              unit_amount: price_to_stripe_format(gross_price),
              product_data: { name: delivery_details.fetch(:label) }
            }
          }
        ]
      end

      def price_to_stripe_format(amount)
        (amount.to_d * PLN_TO_CENTS_MULTIPLIER).round(0, :half_up).to_i
      end
    end
  end
end
