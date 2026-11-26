<a name="boxforchina-"></a>

# Aiursoft BoxForChina

## Overview

### What is BoxForChina?

**Role:** Domestic Acceleration & Traffic Entry

This repository contains the configuration and deployment logic for the **China Region** nodes of the Aiursoft Hybrid Cloud.

<a name="-strategic-objective"></a>

**Strategic objective.**

To provide low-latency access to services for users within Mainland China, bypassing network congestion and ensuring stable connectivity to the core infrastructure.

## Installation

Use a dedicated Linux host with systemd, Git, Bash and sudo access for this Box. The deployment entry point changes host configuration, installs or configures Docker, and deploys Docker Swarm services. Prepare the intended host, its storage and network access before running it.

Fetch the configuration repository:

```bash
git clone https://gitlab.aiursoft.com/aiursoft/boxforchina.git
cd boxforchina
```

Configure the private environment described in Configuration before deployment. This repository configures its named target; it is not a general-purpose installer for an unrelated workstation.

## Usage

<a name="-architecture-specifics"></a>

### Architecture

*   **Ingress:** Optimized for domestic ISPs (China Telecom/Unicom/Mobile).
*   **Routing:** Uses local DNS strategies to route requests:
    *   **Static Assets:** Redirected to local caches or CDNs.
    *   **Dynamic Traffic:** Tunneled to `BoxForProart` via encrypted links.
*   **Restrictions:** Does *not* host heavy storage or heavy compute to minimize VPS costs and legal risks.

<a name="-stacks-included"></a>

### Stacks included

*   **Stage 2 (Network):** 
    *   `baseline`: Basic network connectivity checks.
    *   `build_proxy`: Accelerates build processes for local runners.
    *   `incoming`: The main Caddy reverse proxy entry point.
*   **Stage 4 (Apps):**
    *   Proxies for `ClickHouse`, `Grafana`, `Tracer` (pointing to Core).
    *   Lightweight edge services.

The list above describes the Box's service roles. The tracked `stage*/stacks` directories are the source of truth for the current deployable stack inventory.

### Deployment operations

Select a starting stage and, when needed, a stage-4 stack name filter:

```bash
sudo bash deploy.sh --stage 4 --filter shepherd
```

`--stage` runs the selected stage and all later stages. `--filter` matches a literal substring of stage-4 stack names. A stage-4 request with no matching stack fails before host preparation. From an earlier stage, an intentionally unmatched filter runs infrastructure and shared preparation only.

**Check the result.** On the target Swarm manager, inspect the selected stack and its tasks:

```bash
sudo docker stack ls
sudo docker stack services shepherd
sudo docker stack ps shepherd --no-trunc
```

Replace `shepherd` with the stack being inspected. Confirm the desired replicas, task errors and the service's own health endpoint or application behavior. A successful `docker stack deploy` submission does not prove every service is healthy. For a failed change, inspect task errors and restore a reviewed configuration through the same deployment entry point; preserve existing bind-mounted data.

## Configuration

`deploy.sh` reads `.env.prod` first and falls back to `.env`; it does not merge the two files. Keep real credentials in the private deployment environment. Values replace matching `{{VARIABLE_NAME}}` placeholders in memory before Docker receives the stack over standard input.

Prepare the private file from the tracked [.env](.env) reference and fill in the values required by the selected services:

```bash
cp .env .env.prod
$EDITOR .env.prod
```

`REGISTRY_HOST` and `REGISTRY_VERIFICATION_IMAGE` select the registry and the image used to verify access. `DOCKERHUB_USERNAME` and `DOCKERHUB_PASSWORD` are the deployment registry credentials. `PUBHUB_USERNAME` and `PUBHUB_PASSWORD` provide the separate PubHub bootstrap credentials. The tracked environment reference also lists each application's OIDC, API, mail and other external settings. An absent environment file does not supply defaults for required registry credentials.

Service definitions and bind mounts live in `stage<N>/stacks/<stack-name>/docker-compose.yml`; custom image sources live in `stage<N>/images`. Review these files, the Caddy routes and any FRP configuration together before changing a service's exposure or storage. Keep existing database credentials and persistent data consistent during updates.

<a name="speed-up-docker"></a>

**Speed up docker.**

First, install Xray or other proxy tools that support HTTP proxy on your AnduinOS host.

Then, create or modify the docker systemd service override file to set the HTTP and HTTPS proxy environment variables.

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf > /dev/null <<'EOF'
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

<a name="speed-up-go"></a>

**Speed up Go.**

To speed up Go module downloads in China, set the `GOPROXY` environment variable to use a local Go proxy.

```Dockerfile
ENV GOPROXY=https://goproxy.cn,direct
```

## Development

Validate the configuration using the repository's existing lint entry point:

```bash
bash -n deploy.sh
python3 ./lint.py
```

The linter requires Python 3 and PyYAML. The existing GitLab merge-request pipeline runs the repository's configured lint checks. Syntax and configuration checks do not deploy services or verify a live host.

<a name="-deployment"></a>

Use the supported deployment entry point for the intended target:

```bash
# On a fresh Tencent Cloud / Aliyun / Ningbo Node:
git clone https://gitlab.aiursoft.com/aiursoft/boxforchina.git
cd boxforchina
sudo bash deploy.sh
```

## How to contribute

There are many ways to contribute to the project: logging bugs, submitting pull requests, reporting issues, and creating suggestions.

Even if you have push rights on the repository, you should create a personal fork and create feature branches there when you need them. This keeps the main repository clean and your workflow cruft out of sight.

We're also interested in your feedback on the future of this project. You can submit a suggestion or feature request through the issue tracker. To make this process more effective, we're asking that these include more information to help define them more clearly.

## License

Licensed under the [GNU General Public License v3.0](LICENSE).
