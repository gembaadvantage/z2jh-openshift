# Proof of Concept: Deploying JupyterHub (Z2JH) on CRC

## High-Level Objective
The primary goal of this work is to establish a proof of concept for a customer. Specifically, the objective is to get Zero to JupyterHub (Z2JH) running on a CodeReady Containers (CRC) local Kubernetes cluster.

## Challenges

1. **PodSecurity Policies**: Encountered warnings related to Kubernetes PodSecurity policies that needed resolution.
2. **Resource Allocation**: CRC runs locally and may require significant system resources.
3. etc ...

## Steps

### Pre-requisites
- Running CRC local cluster
- Helm installed
- Local clone of the zero-to-jupyterhub-k8s repository

### Step 1: Clone Internal Forked Repo

```bash
git clone https://bitbucket.org/gembaadvantage/zero-to-jupyterhub-k8s.git
```

### 2. Install/Upgrade Helm Chart

Navigate to the directory of the local clone and run:

```bash
helm upgrade --cleanup-on-fail \                       
  --install z2jh ./jupyterhub \
  --namespace jupyter \
  --create-namespace --debug
```

### TO DO
1. **Ingress?**
2. **config.yaml vs hardcoding changes?**
3. **Correct UBI iamges**