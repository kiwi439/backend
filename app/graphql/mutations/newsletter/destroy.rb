# frozen_string_literal: true

module Mutations
  module Newsletter
    class Destroy < GraphQL::Schema::Mutation
      argument :email, String, required: true
      type Types::Objects::Newsletter::Newsletter, null: true

      def resolve(email:)
        ::Newsletter.find_by(email: email)&.destroy!
      end
    end
  end
end
