FROM ubuntu:22.04



ENV DEBIAN_FRONTEND=noninteractive



RUN apt-get update && \

    apt-get install -y bind9 bind9-utils dnsutils && \

    apt-get clean && \

    rm -rf /var/lib/apt/lists/*



RUN mkdir -p /var/cache/bind /var/lib/bind && \

    chown -R bind:bind /var/cache/bind /var/lib/bind



EXPOSE 53/tcp

EXPOSE 53/udp



CMD ["/usr/sbin/named", "-g", "-u", "bind"]
