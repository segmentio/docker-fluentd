FROM alpine
RUN apk --update add ruby bash ruby-dev
RUN apk add --virtual build-dependencies build-base \
    && echo ":ssl_verify_mode: 0" > ~/.gemrc \
    && gem install fluentd fluent-plugin-docker-tag-resolver --no-rdoc --no-ri \
    && apk del build-dependencies
ADD run.sh /opt/
ENTRYPOINT ["/opt/run.sh"]
