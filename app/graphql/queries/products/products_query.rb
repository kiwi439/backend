# frozen_string_literal: true

module Queries
  module Products
    class ProductsQuery < BaseQuery
      argument :input, Types::Custom::Inputs::Filtrations::Products::ProductInput, required: false
      type Types::Custom::Objects::Products::ProductsObject, null: false

      def resolve(params)
        response = ProductQuery.new(params).call

        {
          products: response[:products],
          total_count: response[:quantity]
        }
      end
    end
  end
end
