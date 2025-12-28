# frozen_string_literal: true

module Mutations
  module Newsletter
    class UnsubscribeUserFromNewsletterMutation < GraphQL::Schema::Mutation
      argument :email, String, required: true
      type Types::Objects::User::User

      def resolve(params)
        # TODO: Jakim cudem zwracam tutaj usera? Błąd typów
        ::Newsletter.find_by(email: params.fetch(:email))&.destroy!
      end
    end
  end
end
