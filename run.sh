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
  format none
  path /var/lib/docker/containers/*/*-json.log
  pos_file /var/lib/docker/containers/containers.log.pos
  tag docker.log.*
</source>

<match docker.log.**>
  type docker_tag_resolver  
</match>

<match docker.container.**>
  type record_reformer
  name \${tag_parts[-2]}
  id \${tag_parts[-1]}
  tenant $OS_TENANT_NAME
  tag \${tag_suffix[1]}
</match>

<match container.**>
  buffer_type memory
  flush_interval 10s
  type forward
  heartbeat_type tcp
  <server>
    host $FLUENTD_HOST
  </server>
</match>

<match **>
  @type stdout
  @id stdout_output
</match>

EOF
exec fluentd -c /etc/fluent/fluent.conf
