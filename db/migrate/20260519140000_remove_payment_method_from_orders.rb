# frozen_string_literal: true

class RemovePaymentMethodFromOrders < ActiveRecord::Migration[7.1]
  def change
    remove_check_constraint :orders,
                           name: 'payment_method_length_check',
                           expression: 'length(payment_method::text) > 0'
    remove_column :orders, :payment_method, :string, null: false, default: 'stripe_payment'
  end
end
