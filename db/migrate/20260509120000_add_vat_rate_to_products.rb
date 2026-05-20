# frozen_string_literal: true

class AddVatRateToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :vat_rate, :integer, null: false
  end
end
