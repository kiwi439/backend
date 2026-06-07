# frozen_string_literal: true

module Queries
  class OrderQuery < BaseQuery
    type Types::Objects::Order::Order, null: true

    argument :id, ID, required: true, description: 'Order ID'

    def resolve(id:)
      user = context.fetch(:current_user)
      return user.orders.find(id) if user.present?

      Order.find(id)
    end
  end
end
