# frozen_string_literal: true

module Orders
  class SubmitOrderService
    extend Utils::CallableObject

    def initialize(params:)
      @order_params = params.except(:products_order)
      @order_products_params = params.fetch(:products_order)
    end

    def call
      order = create_order
      session = create_stripe_checkout_session(order: order)
      create_payment(order: order, session: session)
      session.url
    end

    private

    def create_order
      ActiveRecord::Base.transaction do
        order = Order.new(@order_params)
        add_products_to_order(order: order)
        update_products_quantity(order: order)
        order.save!
        order
      end
    end

    def add_products_to_order(order:)
      @order_products_params.each { |params| order.products_orders << ProductsOrder.new(params) }
    end

    def update_products_quantity(order:)
      order.products_orders.each do |product_order|
        product = product_order.product
        ordered_quantity = product_order.product_quantity
        actual_quantity = product.available_quantity - ordered_quantity

        product.update!(available_quantity: actual_quantity)
      end
    end

    def create_stripe_checkout_session(order:)
      Payments::Stripe::CreateCheckoutSessionService.call(order: order)
    end

    def create_payment(order:, session:)
      Payment.create!(
        order: order,
        status: :pending,
        provider: 'stripe',
        amount_cents: session.amount_total,
        provider_data: {
          checkout_session_id: session.id,
          currency: session.currency,
          redirect_url: session.url,
        }
      )
    end
  end
end
