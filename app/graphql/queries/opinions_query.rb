# frozen_string_literal: true

module Queries
  class OpinionsQuery < BaseQuery
    type Types::Objects::Opinion::Opinion.connection_type, null: false

    def resolve
      Opinion.all.order(:created_at)
    end
  end
end

