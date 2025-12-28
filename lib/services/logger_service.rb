module Services
  class LoggerService
    def initialize(log_path:)
      @logger = Logger.new(Rails.root.join('log', log_path))
    end

    def warn(message:)
      @logger.warn(message)
    end

    def info(message:)
      @logger.info(message)
    end

    def error(message:)
      @logger.error(message)
    end
  end
end
