#!/bin/bash
cat <&0 >./base/resources.yaml
oc kustomize ./openshift/
rm ./base/resources.yaml
