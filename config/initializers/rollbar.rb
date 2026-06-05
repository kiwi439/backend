Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']
  config.environment = Rails.env
  config.enabled = !Rails.env.test?
  config.framework = 'Rails'
  config.use_async = true
end
