# frozen_string_literal: true

class Invoice < ApplicationRecord
  INFAKT_PROVIDER = 'infakt'.freeze
  ALLOWED_PROVIDERS = [INFAKT_PROVIDER].freeze

  belongs_to :order

  validates :provider_name, presence: true, inclusion: { in: ALLOWED_PROVIDERS }
  validates :external_uuid, presence: true, uniqueness: true
end
