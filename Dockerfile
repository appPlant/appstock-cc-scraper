FROM alpine:3.3
MAINTAINER Sebastian Katzer "katzer@appplant.de"

ENV APP_HOME /usr/app/
ENV BUILD_PACKAGES ruby-dev libffi-dev gcc make libc-dev
ENV RUBY_PACKAGES ruby tar curl ruby-json ruby-bundler ruby-io-console

RUN apk update && \
    apk add --no-cache $BUILD_PACKAGES && \
    apk add --no-cache $RUBY_PACKAGES

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile $APP_HOME
COPY Gemfile.lock $APP_HOME
# COPY tmp/isins.txt $APP_HOME/tmp

RUN bundle config path vendor/bundle
RUN bundle install --no-cache --without development test

RUN apk del $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/* && \
    rm -rf /usr/share/ri

COPY . $APP_HOME

CMD ["bundle exec rake scrape:intra"]
