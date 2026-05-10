module Orders
  class CalculateTotalPriceService
    extend Utils::CallableObject

    def initialize(order:)
      @order = order
    end

    def call
      products_price = calculate_products_price
      delivery_price = calculate_delivery_price
      (products_price + delivery_price).round(2)
    end

    private

    def calculate_products_price
      @order.products_orders.map(&:total_gross_price).sum.round(2)
    end

    def calculate_delivery_price
      details = @order.delivery_details
      vat_multiplier = 1 + (BigDecimal(details.fetch(:vat_rate).to_s) / 100)
      netto_price = details.fetch(:price).to_d
      gross_price = (netto_price * vat_multiplier).round(2, :half_up)
      gross_price.to_d
    end
  end
end
