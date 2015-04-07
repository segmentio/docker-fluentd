#!/bin/bash
mkdir /etc/fluent
cat > /etc/fluent/fluent.conf <<EOF
<source>
  type tail
  path /var/lib/docker/containers/*/*-json.log
  pos_file /var/log/fluentd-docker.pos
  time_format %Y-%m-%dT%H:%M:%S
  tag docker.*
  format json
</source>
<match docker.var.lib.docker.containers.*.*.log>
  type record_reformer
  container_id ${tag_parts[5]}
  tenant $OS_TENANT_NAME
  tag docker.all
</match>
<match docker.all>
  type forward
  <server>
    name $FLUENTD_HOST
    host $FLUENTD_HOST
  </server>
</match>
EOF
fluentd -c /etc/fluent/fluent.conf