# frozen_string_literal: true

class BudomanBackendSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end

