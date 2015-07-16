FROM alpine:2.7
RUN apk --update add ruby bash ruby-dev libxslt libxml2 logrotate
RUN apk --update add --virtual build-dependencies build-base libxml2-dev libxslt-dev \
    && echo ":ssl_verify_mode: 0" > ~/.gemrc \
    && gem install fluentd fluent-plugin-record-reformer fluent-plugin-docker-tag-resolver --no-rdoc --no-ri -- --use-system-libraries \
    && apk del build-dependencies
RUN setup-timezone -z /usr/share/zoneinfo/Australia/Sydney
ADD run.sh /opt/
ADD logrotate.d/* /etc/logrotate.d/
ENTRYPOINT ["/opt/run.sh"]
