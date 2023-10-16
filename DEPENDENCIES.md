# Dependencies

## Dev CICD

- [circleci](./.circleci)

### Python

[python](dev-requirements.txt)

- chartpress?!

[jupyterhub](./jupyterhub)
[comment]: <> (Identify ./jupyterhub dependencies below)

### Proxy

- [pebble acme server](https://github.com/letsencrypt/pebblepebble)
- traefik
- jupyter/changable-http-proxy

### Hub

- sqlite-memory

## Prod CICD

[github actions](./.github)

- helm
- pebble

### Dockerfiles

- jupyterhub/k8s-hub
- jupyterhub/configurable-http-proxy
- traefik
- jupyterhub/k8s-secret-sync
- jupyterhub/k8s-network-tools
- jupyterhub/k8s-singleuser-sample
- registry.k8s.io/kube-scheduler
- registry.k8s.io/pause
- jupyterhub/k8s-image-awaiter
