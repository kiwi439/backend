class User < ApplicationRecord
  PASSWORD_REGEX = /\A(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){8,40}\z/i

  has_secure_password

  validates :email,
            uniqueness: { message: 'is already taken!' }, format: { with: EMAIL_REGEX }

  validates_with UserValidator, fields: [:avatars]

  has_many :opinions, dependent: :destroy
  has_many :orders, dependent: :destroy
end
