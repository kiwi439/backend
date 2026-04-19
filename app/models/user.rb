# frozen_string_literal: true

class User < ApplicationRecord
  PASSWORD_REGEX = /\A(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){8,40}\z/i

  has_secure_password

  validates :email, presence: true, uniqueness: { message: 'is already taken!' }, format: { with: Constants::EMAIL_REGEX }
  validates :name, presence: true
  validates :surname, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :phone_number, format: { with: Constants::PHONE_NUMBER_REGEX }, allow_blank: true
  validates :postal_code, format: { with: Constants::POSTAL_CODE_REGEX }, allow_blank: true
  validates_with UserValidator, fields: [:avatars]

  has_many :opinions, dependent: :destroy
  has_many :orders, dependent: :destroy
end
