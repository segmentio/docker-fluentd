# docker-fluentd
collect logs from docker containers, add tags and forward to another fluentd

    docker run -d -e "OS_TENANT_NAME={{ os_tenant_name }}" -e "FLUENTD_HOST={{ fluentd_host }}" -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/containers:/var/lib/docker/containers --name fluentd vault/fluentd
