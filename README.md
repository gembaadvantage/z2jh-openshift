# README

This project adapts the Zero to [Jupyterhub Helm chart](https://github.com/jupyterhub/zero-to-jupyterhub-k8s) for Openshift using a custom values file and Kustomize.

It has been designed and tested using [OpenShift Local](https://developers.redhat.com/products/openshift-local/overview) (formally known as Code Ready Containers).

## Alterations

### The Kustomizations made are as follows

#### Resouces

- Create an openshift route for the application's public proxy.

#### Patches

- Patch the hub, proxy, and singleuser network policies so that named ports are not used. This is because [named port usage in NetworkPolicies aren't supported by the Weave NET Network Policy Controller (NPC)](https://github.com/weaveworks/weave/issues/3032).
- Patch the singleuser network policy egress port to the default-dns service, as the default value in the helm chart isn't correct for OpenShift CRC. This problem prevents the singleuser pods from being able to resolve the "hub" service name, which results in termination of the singleuser pods.
- Patch jupyterhub_config.py configuration file with one that amends thesecurity context for an init container for Openshift. This is run prior to a "singleuser-sample" JupyterHub container starting.

### In the values.yaml file I have made the following changes to the Helm Chart

- Harden the security context of each container.
- Set the runAsUser and runAsGroup values to be empty, this is so that OpenShift generates the UID, GIDs. This is needed because otherwise, it's possible that the defined UID/GID is outside the UID/GID range assigned to the OpenShift project. Please find more information about this [here](https://cloud.redhat.com/blog/a-guide-to-openshift-and-uids).
-

## How to run

cd into this directory; then run:

```bash
helm upgrade \
  --cleanup-on-fail \
  --install jupyterhub jupyterhub/jupyterhub \
  --namespace <namespace-name> \
  --create-namespace \
  --values ./values.yaml \
  --post-renderer ./hook.sh
```

This will apply values to the `jupyterhub/jupyterhub` helm chart, create a new namespace, and then run the `--post-renderer` script. This post renderer will output the result of the populated helm template to a `resources.yaml`. Note, at this point only the `values.yaml` changes have been applied. After this point kustomize is run via the OpenShift CLI, which applies the kustomize openshift overlay to the populated helm template. The temporary `resources.yaml` file is then deleted.

## Notes

- `./openshift/jupyterhub_config.py` is a customisation of [this config file](<https://github.com/jupyterhub/zero-to-jupyterhub-k8s/blob/main/jupyterhub/files/hub/jupyterhub_config.py>).
- Images used in this repo can be found [here](https://bitbucket.org/gembaadvantage/jupyterhub-containers/src/main/), and are customized from the original helm chart. The customized images are based on RedHat UBI:8.

## Contributors

- William Holtam
