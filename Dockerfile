FROM ruby:2.6.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /bitpharma-api
WORKDIR /bitpharma-api

COPY Gemfile /bitpharma-api/Gemfile
COPY . /bitpharma-api

RUN gem install bundler
RUN bundle check || bundle install

CMD bundle exec rails server -b 0.0.0.0
