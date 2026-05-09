#!/bin/bash

# Install dependencies
bundle install

# Setup database
DB_EXISTS=$(rails runner "puts (::ActiveRecord::Base.connection_pool.with_connection(&:active?) rescue false)")

if [ "$DB_EXISTS" = "false" ]; then
  echo "Database does not exist or is not accessible. Creating database, running migrations, and seeding..."
  rails db:create db:migrate db:seed
else
  echo "Database exists. Running migrations..."
  rails db:migrate
fi

# Start the SSH service
service ssh start

# Start cron service
service cron start

# Start sidekiq in background
bundle exec sidekiq &

# Make sure that pid file doesn't exist
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# Start main application
bundle exec rails server -b 0.0.0.0 -p 3333
