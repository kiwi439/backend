# frozen_string_literal: true

module Queries
  class UserQuery < BaseQuery
    type Types::Objects::User::User, null: false

    argument :user_id, ID, required: true, description: 'User ID'

    def resolve(user_id:)
      User.find(user_id)
    end
  end
end
