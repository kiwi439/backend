# frozen_string_literal: true

module Mutations
  module Newsletter
    class SubscribeUserToNewsletterMutation < BaseMutation
      argument :input, Types::Inputs::Mutation::Newsletter::SubscribeUserToNewsletterInput, required: true
      type Types::Objects::User::User

      def resolve(params)
        super(params)
        # TODO: Jakim cudem zwracam tutaj usera a nie newsletter? Błąd typów
        ::Newsletter.create!(email: @params.fetch(:email), name: @params.fetch(:name), surname: @params.fetch(:surname))
      end
    end
  end
end
