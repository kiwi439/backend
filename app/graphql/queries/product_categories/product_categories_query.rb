# frozen_string_literal: true

module Queries
  module ProductCategories
    class ProductCategoriesQuery < BaseQuery
      type [Types::Objects::ProductCategory::ProductCategory], null: false

      def resolve
        ProductCategory.all
      end
    end
  end
end
