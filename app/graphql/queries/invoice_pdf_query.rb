# frozen_string_literal: true

module Queries
  class InvoicePdfQuery < BaseQuery
    type Types::Objects::Invoice::Pdf, null: false

    argument :order_id, ID, required: true, description: 'Order ID'

    def resolve(order_id:)
      user = context.fetch(:current_user)
      order = find_order(user:, order_id:)
      raise GraphQL::ExecutionError, 'Order is not paid' unless order.paid?

      service = Invoices::Infakt::FetchInvoiceService.new(order.invoice.external_uuid)
      response = service.call
      return { pdf_base64: Base64.strict_encode64(response.body) } if service.success?

      raise GraphQL::ExecutionError.new(service.errors)
    end

    private

    def find_order(user:, order_id:)
      return user.orders.find(order_id) if user.present?

      Order.find(order_id)
    end
  end
end
