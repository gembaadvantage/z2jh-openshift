# README

cd into this directory; then run

```bash
helm upgrade \
  --cleanup-on-fail \
  --install z2jh jupyterhub/jupyterhub \
  --namespace jupyter \
  --create-namespace --debug \
  --values config.yaml
  --post-renderer ./hook.sh
```

./openshift/jupyterhub_config.py is an amended version of [this file](<https://github.com/jupyterhub/zero-to-jupyterhub-k8s/blob/main/jupyterhub/files/hub/jupyterhub_config.py>). Consider, better ways to manage a fork of a single file and keep it up to date.
