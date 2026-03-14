# Langfuse Local Project

This repo keeps a pulled copy of Langfuse inside `langfuse/` and provides a script to refresh it.

## Pull the latest Langfuse code

```bash
./scripts/pull-langfuse.sh
```

## Run Langfuse locally (Rancher Desktop friendly)

Rancher Desktop supports two container engines:
- `moby` (Docker CLI + `docker compose`)
- `containerd` (`nerdctl compose`)

Pick one in Rancher Desktop > Preferences > Container Engine, then run:
Note: only one engine is active at a time, and images are not shared between them.

```bash
./scripts/run-langfuse.sh
```

Makefile shortcuts:

```bash
make langfuse-pull
make langfuse-up
```

Manual commands if you prefer:

```bash
cd langfuse

# If using moby (Docker CLI)
docker compose up

# If using containerd (nerdctl)
nerdctl compose up
```

Then open http://localhost:3000 in your browser.

## GitHub Container Registry (GHCR)

If your org blocks `docker.io`, this repo includes `langfuse/docker-compose.override.yml` which rewrites images to
`ghcr.io/kunwarkandari/langfuse/...` and pins tags. Docker Compose loads it automatically when you run from `langfuse/`.

To publish the images into GHCR without using local `docker pull`, trigger the GitHub Actions workflow:
`Publish images to GHCR` in `Actions`.

You can override tags with environment variables:
- `LANGFUSE_IMAGE_TAG` (default `3`)
- `CLICKHOUSE_IMAGE_TAG` (default `latest`)
- `MINIO_IMAGE_TAG` (default `latest`)
- `REDIS_IMAGE_TAG` (default `7`)
- `POSTGRES_IMAGE_TAG` (default `17`)

Example:

```bash
cd langfuse
CLICKHOUSE_IMAGE_TAG=23.12 MINIO_IMAGE_TAG=latest docker compose up
```
