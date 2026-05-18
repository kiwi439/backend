# frozen_string_literal: true

module Mails
  module Order
    class GenerateAtachmentsForOrderCreatedService
      include ServiceStatus

      def initialize(order:)
        @order = order
      end

      def call
        attachments = []
        attachments << { file_name: 'Faktura.pdf', content: invoice_as_binary }
        attachments
      rescue StandardError => e
        errors << e.message
        []
      end

      private

      attr_reader :order

      def invoice_as_binary
        service = Invoices::Infakt::FetchInvoiceService.new(order.invoice.external_uuid)
        response = service.call
        return response if service.success?

        raise "Fetching invoice PDF from Infakt failed: #{service.errors.join(', ')}"
      end
    end
  end
end
