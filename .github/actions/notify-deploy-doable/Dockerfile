FROM ruby:3.3

WORKDIR /app
COPY Gemfile Gemfile.lock ./
COPY entrypoint.rb .
RUN bundle install

ENTRYPOINT ["ruby", "/app/entrypoint.rb"]
