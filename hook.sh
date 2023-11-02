#!/bin/bash
cat <&0 >./base/resources.yaml
kubectl kustomize ./openshift/
rm ./base/resources.yaml
