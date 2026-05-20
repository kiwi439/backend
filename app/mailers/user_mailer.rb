# frozen_string_literal: true

class UserMailer < ApplicationMailer
  ACCOUNT_REGISTERED_TITLE = 'Dziękujemy za rejestrację w naszym serwisie!'.freeze

  def account_registered
    @email = params.fetch(:email)
    @password = params.fetch(:password)

    mail(to: @email, subject: ACCOUNT_REGISTERED_TITLE)
  end
end
