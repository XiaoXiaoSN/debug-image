# Kubernetes All-in-One Debug Image
![Image Build](https://github.com/xiaoxiaosn/debug-image/actions/workflows/build.yaml/badge.svg)

Kubernetes docker images with necessary tools.
Image: `ghcr.io/xiaoxiaosn/debug-image`

## Usage

Install the debug image as a deployment:

```bash
kubectl apply -f https://raw.githubusercontent.com/XiaoXiaoSN/debug-image/main/deployment.yaml
```

Run the debug image as an Ephemeral containers:

```bash
kubectl debug -it $POD_NAME --image=ghcr.io/xiaoxiaosn/debug-image
```

Run a debug pod directly:
```bash
kubectl run debug-image --restart='Never' --image=ghcr.io/xiaoxiaosn/debug-image --command -- sleep infinity
```

### Tips

Check the status of a specified port

```bash
nc -zv localhost 9000
```

### Installed tools

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (latest minor versions: https://kubernetes.io/releases/)
- [kustomize](https://github.com/kubernetes-sigs/kustomize) (latest release: https://github.com/kubernetes-sigs/kustomize/releases/latest)
- [helm](https://github.com/helm/helm) (latest release: https://github.com/helm/helm/releases/latest)
- [helm-diff](https://github.com/databus23/helm-diff) (latest commit)
- [helm-unittest](https://github.com/helm-unittest/helm-unittest) (latest commit)
- [helm-push](https://github.com/chartmuseum/helm-push) (latest commit)
- [aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator) (latest version when run the build)
- [eksctl](https://github.com/weaveworks/eksctl) (latest version when run the build)
- [awscli v1](https://github.com/aws/aws-cli) (latest version when run the build)
- [kubeseal](https://github.com/bitnami-labs/sealed-secrets) (latest version when run the build)
- General tools, such as `bash`, `curl`, `jq`, `yq`, etc

## Reference

Thanks for the other fork [1lann/alpine-k8s](https://github.com/1lann/alpine-k8s) (´･ ∀ ･`)b
