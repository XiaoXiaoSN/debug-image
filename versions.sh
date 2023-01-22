#!/usr/bin/env sh

set -e

# helm latest
helm=$(curl -s https://github.com/helm/helm/releases)
helm=$(echo $helm\" | grep -oP '(?<=tag\/v)[0-9][^"]*' | grep -v \- | sort -Vr | head -1)
echo "⭐️ helm version is $helm"

# kubectl latest
kubectl=$(curl -L -s https://dl.k8s.io/release/stable.txt)
echo "⭐️ kubectl version is $kubectl"

# kustomize latest
kustomize_release=$(curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases | /usr/bin/jq -r '.[].tag_name | select(contains("kustomize"))' \
  | sort -rV | head -n 1)
kustomize_version=$(basename ${kustomize_release})
echo "⭐️ kustomize version is $kustomize_version"

# kubeseal latest
kubeseal_version=$(curl -s https://api.github.com/repos/bitnami-labs/sealed-secrets/releases | /usr/bin/jq -r '.[].tag_name | select(startswith("v"))' \
  | sort -rV | head -n 1 |sed 's/v//')
echo "⭐️ kubeseal version is $kubeseal_version"
