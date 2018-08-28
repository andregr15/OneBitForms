FROM ruby:2.5.1-slim

RUN apt-get update && apt-get install curl gnupg -y

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
    build-essential nodejs libpq-dev imagemagick

ENV INSTALL_PATH /app

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile ./

ENV BUNDLE_PATH /gems

COPY . .