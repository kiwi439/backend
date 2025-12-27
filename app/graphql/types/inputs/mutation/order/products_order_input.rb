# frozen_string_literal: true

module Types
  module Inputs
    module Mutation
      module Order
        class ProductsOrderInput < Types::BaseInputObject
          argument :product_id, ID, required: true
          argument :product_quantity, Integer, required: true
        end
      end
    end
  end
end

