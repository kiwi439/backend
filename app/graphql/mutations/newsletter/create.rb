# frozen_string_literal: true

module Mutations
  module Newsletter
    class Create < BaseMutation
      argument :input, Types::Inputs::Mutation::Newsletter::SubscribeUserToNewsletterInput, required: true
      type Types::Objects::Newsletter::Newsletter, null: false

      def resolve(params)
        super(params)
        ::Newsletter.create!(email: @params.fetch(:email), name: @params.fetch(:name), surname: @params.fetch(:surname))
      end
    end
  end
end
