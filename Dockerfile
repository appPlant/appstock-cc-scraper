FROM alpine:3.3
MAINTAINER Sebastian Katzer "katzer@appplant.de"

ENV APP_HOME /usr/app/
ENV BUILD_PACKAGES ruby-dev libffi-dev build-base
ENV RUBY_PACKAGES ruby curl ruby-json ruby-bundler ruby-io-console

RUN apk update && \
    apk add --no-cache $BUILD_PACKAGES && \
    apk add --no-cache $RUBY_PACKAGES

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile $APP_HOME
COPY Gemfile.lock $APP_HOME
RUN bundle config path vendor/bundle
RUN bundle install --no-cache --without documentation development test

RUN apk del $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/* && \
    rm -rf /usr/share/ri

COPY . $APP_HOME

CMD ["./service"]
