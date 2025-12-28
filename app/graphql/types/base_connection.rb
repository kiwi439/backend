# frozen_string_literal: true

module Types
  class BaseConnection < Types::BaseObject
    include GraphQL::Types::Relay::ConnectionBehaviors

    field :total_count, Integer, null: false, description: 'Total number of items before pagination'

    def total_count
      object.items.except(:limit, :offset).count
    end
  end
end
