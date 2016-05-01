FROM alpine:3.3
MAINTAINER Sebastian Katzer "katzer@appplant.de"

ENV STOCKS_CONCURRENT 35
ENV INTRA_CONCURRENT 200
ENV APP_HOME /usr/app/
ENV BUILD_PACKAGES ruby-dev libffi-dev gcc make libc-dev tzdata
ENV RUBY_PACKAGES ruby tar curl ruby-json ruby-bundler ruby-io-console

RUN apk update && \
    apk add --no-cache $BUILD_PACKAGES && \
    apk add --no-cache $RUBY_PACKAGES && \
    gem update --no-ri --no-rdoc

RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime
RUN echo "Europe/Berlin" >  /etc/timezone

RUN mkdir $APP_HOME
RUN mkdir $APP_HOME/log
WORKDIR $APP_HOME

COPY Gemfile $APP_HOME
COPY Gemfile.lock $APP_HOME
RUN bundle config path vendor/bundle
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install --no-cache --without development test

RUN apk del $BUILD_PACKAGES && \
    gem clean && \
    rm -rf /var/cache/apk/* && \
    rm -rf /usr/share/ri && \
    rm -rf $APP_HOME/vendor/bundle/cache/*.gem && \
    rm -rf $APP_HOME/vendor/bundle/gems/*/test/* && \
    rm -rf $APP_HOME/vendor/bundle/gems/*/spec/*

COPY . $APP_HOME
COPY scripts/init $APP_HOME/init
RUN chmod -R +x $APP_HOME/init

COPY scripts/ /etc/periodic/
RUN chmod -R +x /etc/periodic/

CMD ["./init"]
