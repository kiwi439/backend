# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :order

  validates :provider_name, presence: true
  validates :external_uuid, presence: true, uniqueness: true
end
