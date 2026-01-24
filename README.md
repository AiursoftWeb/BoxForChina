# Box For China

Docker Swarm cluster management tool for users in China, optimized for better performance with local registries and mirrors.

## Speed up docker

First, install Xray or other proxy tools that support HTTP proxy on your AnduinOS host.

Then, create or modify the docker systemd service override file to set the HTTP and HTTPS proxy environment variables.

```bash
sudo cat > /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:10809"
Environment="HTTPS_PROXY=http://127.0.0.1:10809"
Environment="NO_PROXY=localhost,127.0.0.1,registry.cn-hangzhou.aliyuncs.com"
EOF
```

After that, reload the systemd configuration and restart the docker service:

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## Speed up Go

To speed up Go module downloads in China, set the `GOPROXY` environment variable to use a local Go proxy.

```Dockerfile
ENV GOPROXY=https://goproxy.cn,direct
```