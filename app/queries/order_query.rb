# frozen_string_literal: true

class OrderQuery
  def initialize(params)
    @params = params.fetch(:input).to_h
    @orders = Order.all
  end

  def call
    filter_by_membership_to_user_if_need
    total_quantity = @orders.count
    paginate
    sort_by_creation_date
    { orders: @orders, quantity: total_quantity }
  end

  private

  def filter_by_membership_to_user_if_need
    user_id = @params[:user_id]
    return unless user_id

    @orders = User.find(user_id).orders
  end

  def paginate
    page = @params.dig(:pagination, :page)
    quantity_per_page = @params.dig(:pagination, :quantity_per_page)
    return unless page && quantity_per_page

    @orders = @orders.limit(quantity_per_page).offset(page * quantity_per_page)
  end

  def sort_by_creation_date
    @orders = @orders.order(created_at: :desc)
  end
end
