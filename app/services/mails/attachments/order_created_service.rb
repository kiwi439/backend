# frozen_string_literal: true

module Mails
  module Attachments
    class OrderCreatedService < BaseService
      def initialize(order:)
        @order = order
      end

      private

      attr_reader :order

      def build_attachments
        attachments << { file_name: 'Faktura.pdf', content: invoice_pdf }
      end

      def invoice_pdf
        service = Invoices::Infakt::FetchInvoiceService.new(order.invoice.external_uuid)
        response = service.call
        return response.body if service.success?

        raise "Fetching invoice PDF from Infakt failed: #{service.errors.join(', ')}"
      end
    end
  end
end
