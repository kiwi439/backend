# frozen_string_literal: true

module Types
  module Objects
    module Opinion
      class Opinions < Types::BaseObject
        field :opinions, [Opinion], null: false, description: 'List of opinions'
        field :total_count, Integer, null: false, description: 'Total number of opinions'
      end
    end
  end
end
