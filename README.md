![Photon OS](https://img.shields.io/badge/Photon%20OS-5.0-607078?logo=vmware)
![Docker](https://img.shields.io/badge/Docker-Supported-blue?logo=docker)

# Deploy and Host Photon OS Terminal on Railway

Photon OS Terminal is a browser-accessible VMware Photon OS 5.0 shell deployed on Railway via [ttyd](https://github.com/tsl0922/ttyd). Ultra-minimal container-optimized Linux from VMware/Broadcom — password-protected access, persistent storage at `/root`, and essential dev tools and C libraries pre-installed.

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.com/new/template)

## About Hosting Photon OS Terminal

Hosting Photon OS Terminal on Railway means spinning up a Photon OS 5.0 container with a browser-based terminal exposed via ttyd. Photon OS is VMware's open-source container-optimized Linux distribution — RPM-based with a minimal footprint, using `tdnf` (tiny dnf) as its package manager. Railway handles the build, networking, and SSL automatically. The image ships with commonly used C libraries — openssl-devel, zlib-devel, libffi-devel, readline-devel, ncurses-devel, libxml2-devel, libxslt-devel, sqlite-devel, and linux-api-headers — so most language runtimes and native extensions compile without extra setup. A persistent volume is mounted at `/root` so your files survive restarts.

## Common Use Cases

- Testing and building software in a VMware/Broadcom-native Linux environment
- Lightweight cloud shell optimized for containers with a minimal RPM-based footprint
- Learning or working with Photon OS tooling — tdnf, systemd — without a local VM

## Dependencies for Photon OS Terminal Hosting

- [ttyd](https://github.com/tsl0922/ttyd) — browser-based terminal emulator that serves the shell over HTTP
- [Photon OS 5.0](https://github.com/vmware/photon) — VMware's open-source container-optimized Linux distribution

### Deployment Dependencies

- [ttyd 1.7.3 x86_64 binary](https://github.com/tsl0922/ttyd/releases/tag/1.7.3)
- [Photon OS on Docker Hub](https://hub.docker.com/_/photon)
- [Railway Volumes documentation](https://docs.railway.app/reference/volumes)

## Environment Variables

| Variable | Description |
|----------|-------------|
| `PORT` | Port for ttyd to listen on (set automatically by Railway) |
| `USERNAME` | Login username for the web terminal |
| `PASSWORD` | Login password for the web terminal |

> **Note:** Always set USERNAME and PASSWORD before deploying.

## Pre-installed Tools

| Category | Tools |
|---|---|
| Editors | vim, nano |
| System | htop, tree, lsof, less |
| Files | unzip, zip |
| Build | gcc, make |
| Network | ifconfig, ip, ping, openssh |
| Data | jq |
| General | sudo, python3, pip, git, curl, wget |
| Libraries | openssl-devel, zlib-devel, libffi-devel, readline-devel, ncurses-devel, libxml2-devel, libxslt-devel, sqlite-devel, linux-api-headers |

## Installing More Packages

```bash
tdnf install -y <package-name>
```

> **Note:** Files saved inside `/root` persist across restarts. Packages installed via `tdnf` will not survive a full redeploy.

## Why Deploy Photon OS Terminal on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Photon OS Terminal on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
