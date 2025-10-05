# frozen_string_literal: true

class ProductQuery
  def initialize(params)
    @params = params.fetch(:input).to_h
    @products = set_initial_products_scope
  end

  def call
    filter_by_type_if_needed
    filter_by_availability
    count_records
    paginate
    sort_by_price
    response
  end

  private

  def set_initial_products_scope
    return Product.promoted if @params[:promoted]

    Product.all
  end

  def filter_by_type_if_needed
    type = @params[:type]
    return unless type

    @products = @products.from_type(type.underscore)
  end

  def filter_by_availability
    @products = @products.where('available_quantity > ?', 0)
  end

  def count_records
    @records_quantity = @products.count
  end

  def paginate
    page = @params.dig(:pagination, :page)
    quantity_per_page = @params.dig(:pagination, :quantity_per_page)
    return unless page && quantity_per_page

    @products = @products.limit(quantity_per_page).offset(page * quantity_per_page)
  end

  def sort_by_price
    @products = @products.order(:price)
  end

  def response
    { products: @products, quantity: @records_quantity }
  end
end
