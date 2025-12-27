# frozen_string_literal: true

module Types
  module Custom
    module Objects
      module Orders
        class OrdersResult < Types::BaseObject
          field :orders, [Types::Custom::Objects::Orders::OrderObject], null: false
          field :total_count, Integer, null: false
        end
      end
    end
  end
end

