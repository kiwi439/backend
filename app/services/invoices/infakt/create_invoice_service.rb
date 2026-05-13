# frozen_string_literal: true

# order = Order.find('a72c94d2-fca1-42e0-b2b1-b81ab57a7126')
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

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength -- jeden hash żądania API
      def body
        paid_cents = order.latest_payment.amount_cents
        doc_totals = line_net_tax_gross_from_line_gross(paid_cents, 23)

        {
          send_to_ksef: false,
          invoice: {
            kind: 'vat',
            status: 'paid',
            place: order.city,
            sell_date: today,
            issue_date: today,
            paid_date: today,
            paid_price: paid_cents,
            gross_price: doc_totals.fetch(:gross_cents),
            net_price: doc_totals.fetch(:net_cents),
            tax_price: doc_totals.fetch(:tax_cents),
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
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      def invoice_positions
        product_lines + delivery_lines
      end

      # Dla qty > 1: tylko gross_price (brutto linii = Stripe) — bez net/tax na pozycji, żeby inFakt
      # nie przeliczał netta z ceny katalogowej × ilość (różnica 1 gr względem bramki).
      def product_lines
        order.products_orders.includes(:product).map do |po|
          product = po.product
          qty = po.product_quantity
          line_gross_cents = stripe_unit_gross_cents(product) * qty
          base = {
            name: product.name,
            tax_symbol: product.vat_rate.to_s,
            quantity: qty,
            unit: 'szt.'
          }

          if qty > 1
            base.merge(gross_price: line_gross_cents)
          else
            amounts = line_net_tax_gross_from_line_gross(line_gross_cents, product.vat_rate)
            base.merge(
              net_price: amounts.fetch(:net_cents),
              tax_price: amounts.fetch(:tax_cents),
              gross_price: amounts.fetch(:gross_cents)
            )
          end
        end
      end

      def delivery_lines
        details = order.delivery_details
        return [] if details.fetch(:price).to_d.zero?

        vat_rate = details.fetch(:vat_rate)
        netto = details.fetch(:price).to_d
        gross_pln = (netto * (1 + (BigDecimal(vat_rate.to_s) / 100))).round(2, :half_up)
        line_gross_cents = (gross_pln * PLN_TO_CENTS).round(0, :half_up).to_i
        amounts = line_net_tax_gross_from_line_gross(line_gross_cents, vat_rate)

        [{
          name: details.fetch(:label),
          tax_symbol: vat_rate.to_s,
          quantity: 1,
          unit: 'szt.',
          net_price: amounts.fetch(:net_cents),
          tax_price: amounts.fetch(:tax_cents),
          gross_price: amounts.fetch(:gross_cents)
        }]
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
