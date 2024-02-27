#!/usr/bin/env sh

set -e

# helm latest
helm=$(curl -s https://github.com/helm/helm/releases)
helm_version=$(echo "$helm"\" | grep -oP '(?<=tag\/v)[0-9][^"]*' | grep -v \\- | sort -Vr | head -1)
echo "⭐️ helm version is $helm_version"

# kubectl latest
kubectl_version=$(curl -L -s https://dl.k8s.io/release/stable.txt)
echo "⭐️ kubectl version is $kubectl_version"

# kustomize latest
kustomize_release=$(curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases | jq -r '.[].tag_name | select(contains("kustomize"))' \
  | sort -rV | head -n 1)
kustomize_version=$(basename "${kustomize_release}")
echo "⭐️ kustomize version is $kustomize_version"

# kubeseal latest
kubeseal_version=$(curl -s https://api.github.com/repos/bitnami-labs/sealed-secrets/releases | jq -r '.[].tag_name | select(startswith("v"))' \
  | sort -rV | head -n 1 | sed 's/v//')
echo "⭐️ kubeseal version is $kubeseal_version"

# Replace versions in Dockerfile
if [ -n "$1" ]; then
  if [ ! -f "$1" ]; then
    echo "File $1 not found!"
    exit 127
  fi

  sed -i "s/ARG HELM_VERSION=[0-9\.]*/ARG HELM_VERSION=$helm_version/" "$1"
  sed -i "s/ARG KUBECTL_VERSION=v[0-9\.]*/ARG KUBECTL_VERSION=$kubectl_version/" "$1"
  sed -i "s/ARG KUSTOMIZE_VERSION=v[0-9\.]*/ARG KUSTOMIZE_VERSION=$kustomize_version/" "$1"
  sed -i "s/ARG KUBESEAL_VERSION=[0-9\.]*/ARG KUBESEAL_VERSION=$kubeseal_version/" "$1"

  echo "✅ Versions replaced in $1"
fi
