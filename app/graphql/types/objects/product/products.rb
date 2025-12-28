# frozen_string_literal: true

module Types
  module Objects
    module Product
      class Products < Types::BaseObject
        field :products, [Product], null: false, description: 'List of products'
        field :total_count, Integer, null: false, description: 'Total number of products'
      end
    end
  end
end
