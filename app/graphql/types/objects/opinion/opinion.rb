# frozen_string_literal: true

module Types
  module Objects
    module Opinion
      class Opinion < Types::BaseObject
        field :content, String, null: false, description: 'Opinion content'
        field :id, ID, null: false, description: 'Opinion ID'
        field :mark, Integer, null: false, description: 'Opinion mark (rating)'
        field :updated_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'Last update timestamp'
        field :user, Types::Objects::User::User, null: false, description: 'User who created the opinion'
      end
    end
  end
end
