FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /cta-aggregator
WORKDIR /cta-aggregator
ADD Gemfile /cta-aggregator/Gemfile
ADD Gemfile.lock /cta-aggregator/Gemfile.lock
RUN gem install bundler
RUN bundle install
ADD . /cta-aggregator