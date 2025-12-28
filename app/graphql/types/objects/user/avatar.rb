# frozen_string_literal: true

module Types
  module Objects
    module User
      class Avatar < Types::BaseObject
        field :bucket, String, null: false
        field :key, String, null: false
        field :main, String, null: false
      end
    end
  end
end
