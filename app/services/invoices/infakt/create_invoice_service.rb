# frozen_string_literal: true

module Invoices
  module Infakt
    class CreateInvoiceService < BaseService
      def initialize(order:)
        @order = order
      end

      private

      attr_reader :order

      def http_method
        :post
      end

      def headers
        super.merge({ 'Content-Type' => 'application/json; charset=utf-8', 'Accept' => 'application/json' })
      end

      def resource_path
        'api/v3/invoices.json'
      end

      def body
        {
          send_to_ksef: false,
          invoice: {
            kind: 'vat',
            status: 'paid',
            place: order.city,
            sell_date: today,
            issue_date: today,
            paid_date: today,
            paid_price: order.latest_payment.amount_cents,
            left_to_pay: 0,
            payment_method: 'card',
            seller_signature: '',
            client_company_name: "#{order.name} #{order.surname}".strip,
            client_street: order.street,
            client_city: order.city,
            client_post_code: order.postal_code,
            client_email: order.email,
            client_phone: order.phone_number,
            services: invoice_positions
          }
        }
      end

      def invoice_positions
        product_lines + delivery_lines
      end

      def product_lines
        order.products_orders.includes(:product).map do |product_offer|
          product = product_offer.product

          {
            name: product.name,
            tax_symbol: product.vat_rate.to_s,
            quantity: product_offer.product_quantity,
            unit: 'szt.',
            gross_price: product_offer.total_gross_price_cents
          }
        end
      end

      def delivery_lines
        details = order.delivery_details
        return [] if details.fetch(:price).to_d.zero?

        vat_rate = details.fetch(:vat_rate)
        netto_price = details.fetch(:price).to_d
        gross_price = (netto_price * (1 + (BigDecimal(vat_rate.to_s) / 100))).round(2, :half_up)
        gross_price_cents = (gross_price * Constants::PLN_TO_CENTS_MULTIPLIER).round(0, :half_up).to_i

        [{
          name: details.fetch(:label),
          tax_symbol: vat_rate.to_s,
          quantity: 1,
          unit: 'szt.',
          gross_price: gross_price_cents
        }]
      end

      def today
        @today ||= Time.zone.today.iso8601
      end
    end
  end
end
