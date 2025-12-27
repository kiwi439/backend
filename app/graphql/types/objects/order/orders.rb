# frozen_string_literal: true

module Types
  module Objects
    module Order
      class Orders < Types::BaseObject
        field :orders, [Order], null: false
        field :total_count, Integer, null: false
      end
    end
  end
end

