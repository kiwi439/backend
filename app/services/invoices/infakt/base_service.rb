# frozen_string_literal: true

module Invoices
  module Infakt
    class BaseService
      include ServiceStatus

      def call
        response = send_request
        return handle_error(response.parsed_response) unless response.success?

        response
      rescue StandardError => e
        handle_error(e.message)
      end

      private

      def send_request
        case http_method
        when :get
          HTTParty.get(url, headers:, query: query_params)
        when :post
          HTTParty.post(url, headers:, body: body.to_json)
        else
          raise ArgumentError, "Unsupported http_method: #{http_method}"
        end
      end

      def http_method
        raise NotImplementedError, "http_method has to be defined!"
      end

      def url
        "#{Rails.application.config.x.infakt_api_url}/#{resource_path}"
      end

      def resource_path
        raise NotImplementedError, "resource_path has to be defined!"
      end

      def headers
        { 'X-inFakt-ApiKey' => ENV.fetch('INFAKT_API_KEY') }
      end

      def body
        raise NotImplementedError, "body has to be defined!"
      end

      def query_params
        {}
      end

      def handle_error(error)
        errors << error
        nil
      end
    end
  end
end
