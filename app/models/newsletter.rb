class Newsletter < ApplicationRecord
  validates :name, presence: true
  validates :surname, presence: true
  validates :email,
            presence: true,
            uniqueness: { message: 'is already taken!' },
            format: { with: Constants::EMAIL_REGEX }
end
