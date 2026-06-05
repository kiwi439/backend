#!/bin/bash

export RAILS_ENV=development

bundle install

DB_EXISTS=$(rails runner "puts (::ActiveRecord::Base.connection_pool.with_connection(&:active?) rescue false)")

if [ "$DB_EXISTS" = "false" ]; then
  echo "Database does not exist or is not accessible. Creating database, running migrations, and seeding..."
  rails db:create db:migrate db:seed
else
  echo "Database exists. Running migrations..."
  rails db:migrate
fi

service ssh start
service cron start
bundle exec sidekiq &

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec rails server -b 0.0.0.0 -p 3333
