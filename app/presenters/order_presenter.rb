# frozen_string_literal: true

class OrderPresenter
  COMPANY_DETAILS = {
    email: 'siwiec.michal724@gmail.com',
    phone: '724 131 140',
    address: 'Żywiec, 34-300, Beskidzka 50'
  }.freeze

  PRODUCT_CATEGORIES_NAMES = {
    foundation_zone: 'Strefa fundamentu',
    roof_zone: 'Strefa dachu',
    construction_chemicals: 'Materiały chemiczne',
    stairway: 'Schody',
    tools: 'Narzędzia'
  }.freeze

  def initialize(order)
    @order = order
  end

  def company_details
    [
      { field: 'Adres:', value: COMPANY_DETAILS.fetch(:address) },
      { field: 'Telefon:', value: COMPANY_DETAILS.fetch(:phone) },
      { field: 'Adres email:', value: COMPANY_DETAILS.fetch(:email) }
    ]
  end

  def bill_to_details
    [
      { field: 'Nabywca:', value: "#{@order.name} #{@order.surname}" },
      { field: 'Telefon:', value: @order.phone_number },
      { field: 'Adres email:', value: @order.user.email }
    ]
  end

  def ship_to_details
    [
      { field: 'Miasto', value: @order.city },
      { field: 'Kod pocztowy:', value: @order.postal_code },
      { field: 'Ulica:', value: @order.street },
      { field: 'Numer mieszkania:', value: '22' }
    ]
  end

  def rows_names
    ['Nazwa produktu', 'Kategoria', 'Ilość', 'Cena']
  end

  def products_details
    @order.products_orders.map do |product_order|
      product = product_order.product

      {
        name: product.name,
        category_name: PRODUCT_CATEGORIES_NAMES.fetch(product.product_category.name.to_sym),
        quantity: product_order.product_quantity,
        price: product.price
      }
    end
  end

  def total_price
    ::Orders::CalculateTotalPriceService.call(order: @order)
  end
end
