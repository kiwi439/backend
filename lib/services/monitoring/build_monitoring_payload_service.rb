module Services
  module Monitoring
    class BuildMonitoringPayloadService
      extend Utils::CallableObject
      include Utils::ParamsParser

      BuildMonitorResourcePayloadError = Class.new(Errors::RollbarError)

      def initialize(params:)
        @params = params
      end

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def call
        cpu_usages = convert_string_to_hash(string: @params.fetch(:cpu_usage))
        memory_usages = convert_string_to_hash(string: @params.fetch(:mem_info))
        swap_memory_usages = convert_string_to_hash(string: @params.fetch(:swap_info))

        {
          total_memory: memory_usages.fetch(:total),
          used_memory: memory_usages.fetch(:used),
          free_memory: memory_usages.fetch(:free),
          swap_total_memory: swap_memory_usages.fetch(:total),
          swap_used_memory: swap_memory_usages.fetch(:used),
          swap_free_memory: swap_memory_usages.fetch(:free),
          user_cpu_time: cpu_usages.fetch(:us),
          system_cpu_time: cpu_usages.fetch(:sy),
          logged_users: @params.fetch(:logged_users).split,
          recent_actions: @params.fetch(:recent_actions).split,
          public_ip: @params.fetch(:public_ip).strip,
          private_ip: @params.fetch(:private_ip).strip
        }
      rescue StandardError => e
        raise BuildMonitorResourcePayloadError.new(message: e, context_data: { params: @params.to_json })
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
    end
  end
end
