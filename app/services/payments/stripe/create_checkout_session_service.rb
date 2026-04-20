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
          success_url: "#{Rails.configuration.x.frontend_url}/thank-you-page?session_id={CHECKOUT_SESSION_ID}&order_id=#{@order.id}",
          cancel_url: "#{Rails.configuration.x.frontend_url}/payment-canceled",
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
              unit_amount: price_to_stripe_format(product.price),
              product_data: { name: product.name }
            }
          }
        end
      end

      def delivery_line_item
        delivery_details = Order::DELIVERIES_DETAILS.find { |d| d[:method] == @order.delivery_method }
        return [] if delivery_details.fetch(:price).to_d.zero?

        [
          {
            quantity: 1,
            price_data: {
              currency: 'pln',
              unit_amount: price_to_stripe_format(delivery_details.fetch(:price)),
              product_data: { name: delivery_details.fetch(:label) }
            }
          }
        ]
      end

      def price_to_stripe_format(price)
        (price.to_d * PLN_TO_CENTS_MULTIPLIER).round(0, :half_up).to_i
      end
    end
  end
end
