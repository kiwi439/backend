Dotenv.load.each do |env_variable|
  raise "Env variable: #{env_variable.first} not set!" unless env_variable.second.present?
end
