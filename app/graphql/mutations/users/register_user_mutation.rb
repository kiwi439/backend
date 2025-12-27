# frozen_string_literal: true

module Mutations
  module Users
    class RegisterUserMutation < Mutations::BaseMutation
      argument :input, Types::Inputs::Mutation::User::RegisterUserInput, required: true
      type Types::Objects::User::User

      def resolve(params)
        super(params)
        ::Users::Registration::RegisterUserService.call(params: @params, session: context.fetch(:session))
      end
    end
  end
end
