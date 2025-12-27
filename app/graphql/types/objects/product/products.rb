# frozen_string_literal: true

module Types
  module Objects
    module Product
      class Products < Types::BaseObject
        field :products, [Product], null: false
        field :total_count, Integer, null: false
      end
    end
  end
end
