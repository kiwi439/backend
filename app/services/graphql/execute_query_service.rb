module Graphql
  class ExecuteQueryService
    extend Utils::CallableObject

    def initialize(context:)
      @context = context
    end

    def call
      result = BudomanBackendSchema.execute(@context.fetch(:query),
                               variables: @context.fetch(:variables),
                               context: @context.fetch(:context),
                               operation_name: @context.fetch(:operation_name))

      raise StandardError, result['errors'] if result['errors'].present?

      result
    end
  end
end
