# frozen_string_literal: true

module Invoices
  module Infakt
    class BaseService
      include ::ServiceStatus

      def call
        response = HTTParty.post(url, headers:, body: body.to_json)
        binding.pry
      end

      private

      # TODO: "#{Rails.application.config.x.infakt_api_url}/api/v3/invoices.json"
      def url
        "#{Rails.application.config.x.infakt_api_url}/#{resource_path}"
      end

      def resource_path
        raise NotImplementedError, "resource_path has to be defined!"
      end

      def headers
        {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json; charset=utf-8',
          'X-inFakt-ApiKey' => ENV.fetch('INFAKT_API_KEY')
        }
      end

      def body
        raise NotImplementedError, "body has to be defined!"
      end
    end
  end
end
