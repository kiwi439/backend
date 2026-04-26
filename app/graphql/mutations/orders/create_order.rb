# frozen_string_literal: true

module Mutations
  module Orders
    class CreateOrder < BaseMutation
      argument :input, Types::Inputs::Mutation::Order::AddOrderInput, required: true
      type GraphQL::Types::String, null: false

      def resolve(params)
        super(params)
        ::Orders::SubmitOrderService.call(params: @params)
      end
    end
  end
end
