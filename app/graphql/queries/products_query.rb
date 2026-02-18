# frozen_string_literal: true

module Queries
  class ProductsQuery < BaseQuery
    type Types::Objects::Product.connection_type, null: false

    argument :promoted, Boolean, required: false, description: 'Filter by promoted products'
    argument :type, String, required: false, description: 'Filter by product type'

    def resolve(promoted: nil, type: nil)
      products = Product.all
      products = products.promoted if promoted
      products = products.from_type(type.underscore) if type
      products = products.where('available_quantity > ?', 0)
      products = products.order(:price)
      products
    end
  end
end

