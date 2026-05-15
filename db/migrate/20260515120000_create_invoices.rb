# frozen_string_literal: true

class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices, id: :uuid do |t|
      t.references :order, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.string :provider_name, null: false
      t.string :external_uuid, null: false
      t.timestamps
    end

    add_index :invoices, :external_uuid, unique: true
  end
end
