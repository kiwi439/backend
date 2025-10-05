module Services
  module StreamPlatform
    class PublishService
      extend Utils::CallableObject

      PublishOnStreamPlatformError = Class.new(Errors::RollbarError)

      def initialize(topic:, payload:, log_file_name:)
        super()
        @topic = topic
        @payload = payload
        @producer = setup_producer(log_file_name: log_file_name)
      end

      def call
        @producer.produce_sync(topic: @topic, payload: @payload)
      rescue StandardError => e
        raise PublishOnStreamPlatformError.new(message: e.message, context_data: { topic: @topic, payload: @payload })
      end

      private

      def setup_producer(log_file_name:)
        producer = WaterDrop::Producer.new
        producer.setup do |config|
          config.deliver = true
          config.logger = ::Services::LoggerService.new(log_path: log_file_name)
          config.kafka = { 'bootstrap.servers': 'kafka:9092',
                           'request.required.acks': 'all',
                           'enable.idempotence': true }
        end

        producer
      end
    end
  end
end
