# frozen_string_literal: true

module Types
  module Objects
    module ProductCategory
      class ProductCategory < Types::BaseObject
        field :id, ID, null: false, description: 'Product category ID'
        field :name, String, null: false, description: 'Product category name'
      end
    end
  end
end
