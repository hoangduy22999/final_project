FROM ruby:3.0.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs npm && npm install -g yarn
RUN mkdir /final_project
WORKDIR /final_project
ADD Gemfile /final_project/Gemfile
ADD Gemfile.lock /final_project/Gemfile.lock
RUN bundle install
ADD . /final_project