class ProductsOrder < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :product_quantity, numericality: { only_integer: true }

  def total_gross_price
    product_quantity * product.gross_price
  end
end
