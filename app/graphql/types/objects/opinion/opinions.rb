# frozen_string_literal: true

module Types
  module Objects
    module Opinion
      class Opinions < Types::BaseObject
        field :opinions, [Opinion], null: false
        field :total_count, Integer, null: false
      end
    end
  end
end
