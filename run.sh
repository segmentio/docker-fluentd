#!/bin/bash
mkdir /etc/fluent
cat > /etc/fluent/fluent.conf <<EOF
<source>
  type exec
  command logrotate -v /etc/logrotate.d/docker-container
  keys k1
  tag_key k1
  run_interval 10m
</source>

<source>
  type tail
  path /var/lib/docker/containers/*/*-json.log
  pos_file /var/log/fluentd-docker.pos
  time_format %Y-%m-%dT%H:%M:%S
  tag docker.log.*
  format json
</source>

<match docker.log.**>
  type docker_tag_resolver
</match>

<match docker.container.**>
  type record_reformer
  container_name \${tag_parts[-2]}
  container_id \${tag_parts[-1]}
  hostname $OS_TENANT_NAME
  tag \${tag_suffix[1]}
</match>

<match container.**>
  buffer_type memory
  type forward
  heartbeat_type tcp
  <server>
    host $FLUENTD_HOST
    port 24224
  </server>
</match>

<match **>
  @type stdout
  @id stdout_output
</match>

EOF
exec fluentd -c /etc/fluent/fluent.conf
