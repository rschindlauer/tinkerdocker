# Docker image for an iot env

## Build

Use a specific timestamp and/or `latest`:

```bash
docker build -t docker-iot:2021-12-12 .
```

## Setup

Run the setup script (needs ssh keys mounted from the host system, that's why it's not in the Dockerfile):

```bash
./setup.sh
```
