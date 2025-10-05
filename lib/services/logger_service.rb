module Services
  class LoggerService
    def initialize(file_name:)
      @logger = Logger.new(Rails.root.join('log', file_name)) # TODO: To moze być path_name a nie file_name
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
