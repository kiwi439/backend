module Services
  module Monitoring
    class HandleMonitorResourcesService
      extend Utils::CallableObject

      TOPIC_NAME = 'monitor_resources'.freeze
      SCHEMA_NAME = 'monitor_resources'.freeze
      LOG_FILE_NAME = 'monitoring_system.log'.freeze

      def initialize(params:)
        super()
        @params = params
      end

      def call
        payload = build_payload
        encoded_payload = validate_and_encode_payload(payload: payload)
        publish_event(payload: encoded_payload)
        handle_success
      rescue StandardError => e
        handle_error(error: e)
      end

      private

      def build_payload
        ::Services::Monitoring::BuildMonitoringPayloadService.call(params: @params)
      end

      def validate_and_encode_payload(payload:)
        ::Services::StreamPlatform::ValidateAndEncodePayloadService.call(payload: payload, schema_name: SCHEMA_NAME)
      end

      def publish_event(payload:)
        ::Services::StreamPlatform::PublishService.call(topic: TOPIC_NAME, payload: payload, log_file_name: LOG_FILE_NAME)
      end

      def handle_success
        ::Services::LoggerService.new(log_path: LOG_FILE_NAME).info(message: 'Event succesfully published on stream platform!')
        true
      end

      def handle_error(error:)
        ::Services::LoggerService.new(log_path: LOG_FILE_NAME).warn(message: "Event publication failed!\n\
                                                                               Context: #{error&.rollbar_context || {}}\n\
                                                                               Error message: #{error.message}\n\
                                                                               Error backtrace:\n#{error.backtrace.first(3).join("\n")}\n")
        Rollbar.warn(error)
        false
      end
    end
  end
end
