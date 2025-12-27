# frozen_string_literal: true

module Queries
  module Opinions
    class OpinionsQuery < BaseQuery
      argument :input, Types::Custom::Inputs::Filtrations::Opinions::OpinionInput, required: false
      type Types::Custom::Objects::Opinions::OpinionsObject, null: false

      def resolve(params)
        {
          opinions: OpinionQuery.new(params).call,
          total_count: Opinion.count
        }
      end
    end
  end
end
