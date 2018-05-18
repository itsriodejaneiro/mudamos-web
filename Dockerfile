FROM ruby:2.5.1

RUN apt-get update -qq

RUN apt-get install -y \
    build-essential \
    libpq-dev \
    git \
    imagemagick \
    yarn \
    tzdata

RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

ADD . /app

# Start up
CMD ["docker/startup.sh"]
