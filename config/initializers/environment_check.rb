return if Rails.env.test?

raise 'AWS_ACCESS_KEY_ID not set!' if ENV['AWS_ACCESS_KEY_ID'].blank?
raise 'AWS_SECRET_ACCESS_KEY not set!' if ENV['AWS_SECRET_ACCESS_KEY'].blank?
raise 'STRIPE_SECRET_KEY not set!' if ENV['STRIPE_SECRET_KEY'].blank?
raise 'STRIPE_WEBHOOK_SIGNING_SECRET not set!' if ENV['STRIPE_WEBHOOK_SIGNING_SECRET'].blank?
raise 'INFAKT_API_KEY not set!' if ENV['INFAKT_API_KEY'].blank?
raise 'SMTP_PASSWORD not set!' if ENV['SMTP_PASSWORD'].blank?
raise 'SIDEKIQ_PANEL_LOGIN not set!' if ENV['SIDEKIQ_PANEL_LOGIN'].blank?
raise 'SIDEKIQ_PANEL_PASSWORD not set!' if ENV['SIDEKIQ_PANEL_PASSWORD'].blank?
raise 'ROLLBAR_ACCESS_TOKEN not set!' if ENV['ROLLBAR_ACCESS_TOKEN'].blank?
