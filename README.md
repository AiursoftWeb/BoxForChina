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

## 🚀 Deployment

```bash
# On a fresh Tencent Cloud / Aliyun / Ningbo Node:
git clone https://gitlab.aiursoft.cn/aiursoft/bash-app.git
cd bash-app/Boxes/BoxForChina
sudo bash deploy.sh
```