FROM alpine
RUN apk --update add ruby bash ruby-dev libxslt libxml2
RUN apk add --virtual build-dependencies build-base libxml2-dev libxslt-dev libiconv-dev \
    && echo ":ssl_verify_mode: 0" > ~/.gemrc \
    && gem install fluentd fluent-plugin-record-reformer --no-rdoc --no-ri -- --use-system-libraries \
    && apk del build-dependencies
ADD run.sh /opt/
ENTRYPOINT ["/opt/run.sh"]
