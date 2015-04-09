# docker-fluentd
collect logs from docker containers and upload them to another fluentd

    docker run -d -v /var/run/docker.sock:/var/run/docker.sock -e "OS_TENANT_NAME={{ os_tenant_name }}" -e "FLUENTD_HOST={{ fluentd_host }}" -v /var/lib/docker/containers:/var/lib/docker/containers --name fluentd vault/fluentd
