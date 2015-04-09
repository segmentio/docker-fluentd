#!/bin/bash
mkdir /etc/fluent
cat > /etc/fluent/fluent.conf <<EOF
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
  image \${tag_parts[2]}
  name \${tag_parts[3]}
  id \${tag_parts[4]}
  tenant $OS_TENANT_NAME
  tag docker
</match>

<match docker>
  type forward
  heartbeat_type tcp
  <server>
    host $FLUENTD_HOST
  </server>
</match>
EOF
exec fluentd -c /etc/fluent/fluent.conf