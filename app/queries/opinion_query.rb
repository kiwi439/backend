# frozen_string_literal: true

class OpinionQuery
  def initialize(params)
    @params = params.fetch(:input).to_h
    @opinions = Opinion.all
  end

  def call
    paginate
    sort_by_creation_date
    @opinions
  end

  private

  def paginate
    page = @params.dig(:pagination, :page)
    quantity_per_page = @params.dig(:pagination, :quantity_per_page)
    return unless page && quantity_per_page

    @opinions = @opinions.limit(quantity_per_page).offset(page * quantity_per_page)
  end

  def sort_by_creation_date
    @opinions = @opinions.order(:created_at)
  end
end
