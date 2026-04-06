# BoxForChina 🇨🇳

**Role:** Domestic Acceleration & Traffic Entry

This repository contains the configuration and deployment logic for the **China Region** nodes of the Aiursoft Hybrid Cloud.

## 🎯 Strategic Objective
To provide low-latency access to services for users within Mainland China, bypassing network congestion and ensuring stable connectivity to the core infrastructure.

## 🏗 Architecture Specifics
*   **Ingress:** Optimized for domestic ISPs (China Telecom/Unicom/Mobile).
*   **Routing:** Uses local DNS strategies to route requests:
    *   **Static Assets:** Redirected to local caches or CDNs.
    *   **Dynamic Traffic:** Tunneled to `BoxForProart` via encrypted links.
*   **Restrictions:** Does *not* host heavy storage or heavy compute to minimize VPS costs and legal risks.

## 📦 Stacks Included
*   **Stage 2 (Network):** 
    *   `baseline`: Basic network connectivity checks.
    *   `build_proxy`: Accelerates build processes for local runners.
    *   `incoming`: The main Caddy reverse proxy entry point.
*   **Stage 4 (Apps):**
    *   Proxies for `ClickHouse`, `Grafana`, `Tracer` (pointing to Core).
    *   Lightweight edge services.

## 🌐 IPv6 Support

This project natively supports **Dual-Stack (IPv4 & IPv6)** connectivity. 

*   **Ingress:** The Caddy gateway (`incoming` stack) is configured in `mode: host`, allowing it to bind directly to the host's global unicast IPv6 addresses.
*   **Internal:** The `deploy.sh` script automatically configures a dual-stack Docker Swarm network.
*   **Verification:** Ensure your host has a valid IPv6 address and that your cloud provider's firewall allows incoming traffic on ports 80 and 443 via IPv6.

## 🚀 Deployment

```bash
# On a fresh Tencent Cloud / Aliyun / Ningbo Node:
git clone https://gitlab.aiursoft.cn/aiursoft/bash-app.git
cd bash-app/Boxes/BoxForChina
sudo bash deploy.sh
```

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