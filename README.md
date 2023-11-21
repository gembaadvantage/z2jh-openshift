# README

This project adapts the Zero to [Jupyterhub Helm chart](https://github.com/jupyterhub/zero-to-jupyterhub-k8s) for Openshift using a custom values file and Kustomize.

The Kustomizations made for openshift are:

- Create an openshift route for the application's public proxy.
- Patch the hub, proxy, and singleuser network policies so that named ports are not used. This is because [named port usage in NetworkPolicies aren't supported by the Weave NET Network Policy Controller (NPC)](https://github.com/weaveworks/weave/issues/3032).
- Patch the singleuser network policy egress port to the default-dns service, as the default value in the helm chart isn't correct for OpenShift CRC. This problem prevents the singleuser pods from being able to resolve the "hub" service name, which results in termination of the singleuser pods.
- Replace jupyterhub_config.py configuration file with one that amends thesecurity context for an init container for Openshift. This is run prior to a "singleuser-sample" JupyterHub container starting.

## How to run

cd into this directory; then run:

```bash
helm upgrade \
  --cleanup-on-fail \
  --install jupyterhub jupyterhub/jupyterhub \
  --namespace <namespace-name> \
  --create-namespace --debug \
  --values ./values.yaml
  --post-renderer ./hook.sh
```

## Notes

- ./openshift/jupyterhub_config.py is a customisation of [this config file](<https://github.com/jupyterhub/zero-to-jupyterhub-k8s/blob/main/jupyterhub/files/hub/jupyterhub_config.py>).
- Images used in this repo can be found [here](https://bitbucket.org/gembaadvantage/jupyterhub-containers/src/main/), and are customized from the original helm chart. The customized images are based on RedHat UBI:8.

## Contributors

- [William Holtam](will.holtam@gembaadvantage.com)
