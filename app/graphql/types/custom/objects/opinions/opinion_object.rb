# frozen_string_literal: true

module Types
  module Custom
    module Objects
      module Opinions
        class OpinionObject < Types::BaseObject
          field :id, ID, null: false
          field :content, String, null: false
          field :mark, Integer, null: false
          field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
          field :user, Types::Objects::User::User, null: false
        end
      end
    end
  end
end
