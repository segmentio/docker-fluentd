FROM alpine
RUN apk --update add ruby bash ruby-dev libxslt libxml2 logrotate
RUN apk add --virtual build-dependencies build-base libxml2-dev libxslt-dev libiconv-dev tzdata \
    && echo ":ssl_verify_mode: 0" > ~/.gemrc \
    && gem install fluentd fluent-plugin-record-reformer fluent-plugin-docker-tag-resolver --no-rdoc --no-ri -- --use-system-libraries \
    && cp /usr/share/zoneinfo/Australia/Sydney /etc/localtime \    
    && apk del build-dependencies
ADD run.sh /opt/
ENTRYPOINT ["/opt/run.sh"]
