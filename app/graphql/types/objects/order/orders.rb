# frozen_string_literal: true

module Types
  module Objects
    module Order
      class Orders < Types::BaseObject
        field :orders, [Order], null: false, description: 'List of orders'
        field :total_count, Integer, null: false, description: 'Total number of orders'
      end
    end
  end
end
