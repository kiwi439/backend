class ProductsOrder < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :product_quantity, numericality: { only_integer: true }

  def total_gross_price
    product_quantity * product.gross_price
  end

  def total_gross_price_cents
    (total_gross_price.to_d * Constants::PLN_TO_CENTS_MULTIPLIER).round(0, :half_up).to_i
  end
end
