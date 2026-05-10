class Product < ApplicationRecord
  belongs_to :product_category
  has_many :products_orders

  validates :name, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :available_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :picture_key, presence: true
  validates :picture_bucket, presence: true
  validates :vat_rate, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :promoted, -> { where('promoted_from <= ? AND promoted_to > ?', Time.now, Time.now) }
  scope :from_type, ->(type) { joins(:product_category).where(product_categories: { name: type }) }

  def gross_price
    netto_price = price.to_d
    vat_multiplier = 1 + (BigDecimal(vat_rate.to_s) / 100)
    (netto_price * vat_multiplier).round(2, :half_up)
  end
end
