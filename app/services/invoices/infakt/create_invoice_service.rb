# frozen_string_literal: true

# order = Order.find('1f0ad2ff-f95b-4869-9e2e-6788e1545aac')
# service = Invoices::Infakt::CreateInvoiceService.new(order:)
# service.call

# TODO: Refactor

module Invoices
  module Infakt
    class CreateInvoiceService < BaseService
      PLN_TO_CENTS = 100

      def initialize(order:)
        super()
        @order = order
      end

      private

      attr_reader :order

      def resource_path
        'api/v3/async/invoices.json'
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

      # net_price / tax_price / gross_price = sumy linii w groszach (jak Stripe: brutto jednostki × ilość).
      def product_lines
        order.products_orders.includes(:product).filter_map do |po|
          product = po.product
          qty = po.product_quantity
          next if qty <= 0

          service_line_hash(
            name: product.name,
            tax_symbol: product.vat_rate.to_s,
            quantity: qty.to_s,
            line_gross_cents: stripe_unit_gross_cents(product) * qty
          )
        end
      end

      def delivery_lines
        details = order.delivery_details
        return [] if details.fetch(:price).to_d.zero?

        vat_rate = details.fetch(:vat_rate)
        netto = details.fetch(:price).to_d
        vat_mult = 1 + (BigDecimal(vat_rate.to_s) / 100)
        gross_pln = (netto * vat_mult).round(2, :half_up)
        line_gross_cents = (gross_pln * PLN_TO_CENTS).round(0, :half_up).to_i

        [
          service_line_hash(
            name: details.fetch(:label),
            tax_symbol: vat_rate.to_s,
            quantity: '1',
            line_gross_cents: line_gross_cents
          )
        ]
      end

      def service_line_hash(name:, tax_symbol:, quantity:, line_gross_cents:)
        amounts = line_net_tax_gross_from_line_gross(line_gross_cents, tax_symbol.to_i)
        {
          name: name,
          tax_symbol: tax_symbol,
          quantity: quantity,
          unit: 'szt.',
          net_price: amounts.fetch(:net_cents),
          tax_price: amounts.fetch(:tax_cents),
          gross_price: amounts.fetch(:gross_cents)
        }
      end

      def today
        @today ||= Time.zone.today.iso8601
      end

      def stripe_unit_gross_cents(product)
        (product.gross_price.to_d * PLN_TO_CENTS).round(0, :half_up).to_i
      end

      def line_net_tax_gross_from_line_gross(line_gross_cents, vat_rate_percent)
        gross_pln = BigDecimal(line_gross_cents) / PLN_TO_CENTS
        divisor = 1 + (BigDecimal(vat_rate_percent.to_s) / 100)
        net_pln = (gross_pln / divisor).round(2, :half_up)
        net_cents = (net_pln * PLN_TO_CENTS).round(0, :half_up).to_i
        tax_cents = line_gross_cents - net_cents

        {
          net_cents: net_cents,
          tax_cents: tax_cents,
          gross_cents: line_gross_cents
        }
      end
    end
  end
end
