# frozen_string_literal: true

module Constants
  PLN_TO_CENTS_MULTIPLIER = 100.0

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  PHONE_NUMBER_REGEX = /\A[0-9]{9}\z/
  POSTAL_CODE_REGEX = /\A\d{2}-\d{3}\z/
end
