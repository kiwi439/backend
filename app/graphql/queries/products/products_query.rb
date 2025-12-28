# frozen_string_literal: true

module Queries
  module Products
    class ProductsQuery < BaseQuery
      argument :input, Types::Inputs::Query::ProductInput, required: false
      type Types::Objects::Product::Products, null: false

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
