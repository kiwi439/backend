# frozen_string_literal: true

module Queries
  class CurrentUserQuery < BaseQuery
    type Types::Objects::User::User, null: true

    def resolve
      context.fetch(:current_user)
    end
  end
end
