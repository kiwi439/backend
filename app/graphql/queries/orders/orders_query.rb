# frozen_string_literal: true

module Queries
  module Orders
    class OrdersQuery < BaseQuery
      type Types::Objects::Order::Order.connection_type, null: false

      argument :user_id, ID, required: false, description: 'Filter orders by user'

      def resolve(user_id: nil)
        orders = Order.order(created_at: :desc)
        orders = User.find(user_id).orders.order(created_at: :desc) if user_id
        orders
      end
    end
  end
end
