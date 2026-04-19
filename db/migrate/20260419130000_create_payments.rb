# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments, id: :uuid do |t|
      t.references :order, null: false, foreign_key: true, type: :uuid
      t.string :status, null: false, default: 'pending'
      t.string :provider, null: false
      t.integer :amount_cents, null: false
      t.jsonb :provider_data, null: false, default: {}
      t.timestamps
    end
  end
end
