# frozen_string_literal: true

module Invoices
  module Infakt
    class FetchInvoiceService < BaseService
      def initialize(invoice_uuid)
        @invoice_uuid = invoice_uuid
      end

      private

      attr_reader :invoice_uuid

      def http_method
        :get
      end

      def headers
        super.merge({ 'Accept' => 'application/pdf' })
      end

      def resource_path
        "api/v3/invoices/#{invoice_uuid}/pdf.json"
      end

      def query_params
        { document_type: 'original' }
      end
    end
  end
end
