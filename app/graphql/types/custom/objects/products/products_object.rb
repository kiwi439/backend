# frozen_string_literal: true

module Types
  module Custom
    module Objects
      module Products
        class ProductsObject < Types::BaseObject
          field :products, [Types::Custom::Objects::Products::ProductObject], null: false
          field :total_count, Integer, null: false
        end
      end
    end
  end
end

