# frozen_string_literal: true

module Mutations
  module Tools
    class MonitorResourcesMutation < Mutations::BaseMutation
      argument :input, Types::Inputs::Mutation::Tool::MonitorResourcesInput, required: true
      type Boolean

      def resolve(params)
        super(params)
        ::Services::Monitoring::HandleMonitorResourcesService.call(params: @params)
      end
    end
  end
end
