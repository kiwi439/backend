# frozen_string_literal: true

module Mutations
  module Users
    class LoginMutation < BaseMutation
      argument :input, Types::Inputs::Mutation::User::LoginUserInput, required: true
      type Types::Objects::User::User

      def resolve(params)
        super(params)
        ::Users::LoginUserService.call(params: @params, session: context.fetch(:session))
      end
    end
  end
end
