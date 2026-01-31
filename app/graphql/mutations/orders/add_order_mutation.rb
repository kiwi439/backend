# frozen_string_literal: true

# TODO: CreateMutation
module Mutations
  module Orders
    class AddOrderMutation < Mutations::BaseMutation
      argument :input, Types::Inputs::Mutation::Order::AddOrderInput, required: true
      type Types::Objects::Order::Order

      def resolve(params)
        super(params)
        ::Orders::CreateOrderService.call(params: @params)
      end
    end
  end
end
