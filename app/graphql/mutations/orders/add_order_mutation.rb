# frozen_string_literal: true

module Mutations
  module Orders
    class AddOrderMutation < Mutations::BaseMutation
      argument :input, Types::Custom::Inputs::Mutations::Orders::AddOrderInput, required: true
      type Types::Objects::Order::Order

      def resolve(params)
        super(params)
        ::Orders::CreateOrderService.call(params: @params)
      end
    end
  end
end
