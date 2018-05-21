FROM ruby:2.5.1

# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run
RUN apt-get autoremove -y imagemagick \
    && apt-get update -qq \
    && apt-get install -y \
      build-essential \
      libpq-dev \
      tzdata \
      ghostscript \
      && rm -rf /var/lib/apt/lists/*

ENV DEPENDENCIES_FOLDER /dependencies
RUN mkdir -p $DEPENDENCIES_FOLDER && cd $DEPENDENCIES_FOLDER

COPY docker/install-image-magick.sh .
RUN ./install-image-magick.sh && cd /

# Add imagemagick to PATH
ENV MAGICK_CONFIGURE_PATH=$DEPENDENCIES_FOLDER/imagemagick/build/vendor/imagemagick
ENV PATH=$MAGICK_CONFIGURE_PATH/bin:$PATH
ENV LD_LIBRARY_PATH=$MAGICK_CONFIGURE_PATH/lib:$LD_LIBRARY_PATH

ENV APP_ROOT /app
ENV RAILS_ENV=production
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

COPY Gemfile Gemfile.lock ./
RUN bundle install --deployment --binstubs --without test:development --jobs 4 --retry 5

COPY . ./

RUN SECRET_KEY_BASE=devisefoo bundle exec rake assets:precompile

CMD ["docker/startup.sh"]
