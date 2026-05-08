# frozen_string_literal: true

#! Aplikacja - 10.99 InPost + 359,99 produkty
#! Bramka platnosci - 370.98
#! Razem do zaplaty faktura - 370,96
# TODO: Refaktor + upewnic sie czy to dziala

module Invoices
  module Infakt
    class CreateInvoiceService < BaseService
      VAT_DIVISOR = BigDecimal('1.23')
      TAX_SYMBOL = '23'

      def initialize(order:)
        @order = order
      end

      private

      attr_reader :order

      def resource_path
        'api/v3/async/invoices.json'
      end

      def body
        {
          invoice: invoice_attributes,
          send_to_ksef: false
        }
      end

      def invoice_attributes
        {
          kind: 'vat',
          status: 'paid',
          place: order.city,
          sell_date: today,
          issue_date: today,
          paid_date: today,
          paid_price: order.total_price.to_i * 100,
          payment_method: 'card',
          seller_signature: '',
          client_company_name: "#{order.name} #{order.surname}".strip,
          client_street: order.street,
          client_city: order.city,
          client_post_code: order.postal_code,
          client_email: order.email,
          client_phone: order.phone_number,
          services: invoice_services
        }
      end

      def invoice_services
        product_lines + [delivery_line]
      end

      def product_lines
        order.products_orders.includes(:product).map do |po|
          {
            name: po.product.name,
            tax_symbol: TAX_SYMBOL,
            unit_net_price: net_price_in_grosze(po.product.price),
            quantity: po.product_quantity.to_s,
            unit: 'szt.'
          }
        end
      end

      def delivery_line
        details = Order::DELIVERIES_DETAILS.find { |d| d.fetch(:method) == order.delivery_method }
        {
          name: details.fetch(:label),
          tax_symbol: TAX_SYMBOL,
          unit_net_price: net_price_in_grosze(details.fetch(:price)),
          quantity: '1',
          unit: 'szt.'
        }
      end

      def today
        @today ||= Time.zone.today.iso8601
      end

      def net_price_in_grosze(brutto_pln)
        brutto = BigDecimal(brutto_pln.to_s)
        net = brutto / VAT_DIVISOR
        (net * 100).round.to_i
      end
    end
  end
end
