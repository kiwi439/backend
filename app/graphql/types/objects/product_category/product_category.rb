# frozen_string_literal: true

module Types
  module Objects
    module ProductCategory
      class ProductCategory < Types::BaseObject
        field :id, ID, null: false
        field :name, String, null: false
      end
    end
  end
end
