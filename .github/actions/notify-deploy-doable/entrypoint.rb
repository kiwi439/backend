# frozen_string_literal: true

require 'mail'

TO = 'siwiec.michal724@gmail.com'
SMTP = {
  host: 'smtp.gmail.com',
  port: 587,
  user: 'siwiec.michal724@gmail.com'
}.freeze

password = ENV['INPUT_SMTP-PASSWORD']
raise 'smtp-password is required!' if password.nil? || password.empty?

Mail.deliver do
  from SMTP[:user]
  to TO
  subject 'Deploy is doable - each tests passed'
  body <<~BODY
    Deploy is doable - each tests passed. You can deploy now.
    Repository: #{ENV['INPUT_REPOSITORY'].to_s}
    Commit: #{ENV['INPUT_COMMIT-SHA'].to_s}
  BODY
  delivery_method :smtp, address: SMTP[:host],
                         port: SMTP[:port],
                         user_name: SMTP[:user],
                         password: password,
                         authentication: :plain,
                         enable_starttls_auto: true
end

puts 'Email sent successfully.'
