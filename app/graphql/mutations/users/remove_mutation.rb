# frozen_string_literal: true

module Mutations
  module Users
    class RemoveMutation < GraphQL::Schema::Mutation
      argument :user_id, ID, required: true
      type Types::Objects::User::User

      def resolve(user_id:)
        ::Users::RemoveUserService.call(user_id: user_id, session: context.fetch(:session))
      end
    end
  end
end
