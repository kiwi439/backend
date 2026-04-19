# frozen_string_literal: true

# TODO: Poprawić to
module Payments
  module Stripe
    class CreateCheckoutSessionService
      extend Utils::CallableObject

      def initialize(order:)
        @order = order
      end

      def call
        line_items = product_line_items
        line_items += delivery_line_item

        frontend = Rails.configuration.x.frontend_url.to_s.sub(%r{/\z}, '')

        Stripe::Checkout::Session.create(
          mode: 'payment',
          line_items: line_items,
          success_url: "#{frontend}/thank-you-page?session_id={CHECKOUT_SESSION_ID}",
          cancel_url: "#{frontend}/payment-canceled",
          metadata: { order_id: @order.id.to_s },
          client_reference_id: @order.id.to_s
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
              unit_amount: money_to_stripe_unit_amount(product.price),
              product_data: { name: product.name }
            }
          }
        end
      end

      def delivery_line_item
        details = Order::DELIVERIES_DETAILS.find { |d| d[:method] == @order.delivery_method }
        return [] if details.nil?

        price = details[:price]
        return [] if price.to_d.zero?

        [
          {
            quantity: 1,
            price_data: {
              currency: 'pln',
              unit_amount: money_to_stripe_unit_amount(price),
              product_data: { name: delivery_line_name(@order.delivery_method) }
            }
          }
        ]
      end

      def delivery_line_name(delivery_method)
        {
          'in_post' => 'Dostawa: Paczkomat InPost',
          'dpd' => 'Dostawa: DPD',
          'pick_up_at_the_point' => 'Odbiór osobisty'
        }.fetch(delivery_method)
      end

      def money_to_stripe_unit_amount(amount)
        (amount.to_d * 100).round(0, :half_up).to_i
      end
    end
  end
end
