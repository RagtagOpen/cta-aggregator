FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /cta-aggregator
WORKDIR /cta-aggregator
COPY Gemfile.lock Gemfile /cta-aggregator/
RUN gem install bundler
RUN bundle install
# COPY . /cta-aggregator
