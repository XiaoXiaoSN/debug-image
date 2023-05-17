FROM alpine:3

ARG HELM_VERSION=3.12.0
ARG KUBECTL_VERSION=v1.27.1
ARG KUSTOMIZE_VERSION=v5.0.3
ARG KUBESEAL_VERSION=0.21.0
ARG TARGETARCH

ARG WITH_EKS

ARG BUILD_TIME

# Install useful tools
RUN apk add --update --no-cache \
    bash \
    bind-tools \
    ca-certificates \
    curl \
    gettext \
    git \
    grep \
    tar \
    tcpdump \
    jq

# Install helm (latest release)
# ENV BASE_URL="https://storage.googleapis.com/kubernetes-helm"
ENV BASE_URL="https://get.helm.sh"
ENV TAR_FILE="helm-v${HELM_VERSION}-linux-${TARGETARCH}.tar.gz"
RUN curl -sL ${BASE_URL}/${TAR_FILE} | tar -xvz && \
    mv linux-${TARGETARCH}/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-${TARGETARCH}

# add helm-diff, helm-unittest, helm-push
RUN helm plugin install https://github.com/databus23/helm-diff && \
    helm plugin install https://github.com/quintush/helm-unittest && \
    helm plugin install https://github.com/chartmuseum/helm-push && \
    rm -rf /tmp/helm-*

# Install kubectl (same version of aws esk)
RUN curl -sLO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl && \
    mv kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

# Install kustomize (latest release)
RUN curl -sLO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_${TARGETARCH}.tar.gz && \
    tar xvzf kustomize_${KUSTOMIZE_VERSION}_linux_${TARGETARCH}.tar.gz && \
    mv kustomize /usr/bin/kustomize && \
    chmod +x /usr/bin/kustomize

# Install eksctl (latest version), awscli, and aws-iam-authenticator
RUN if [ "$WITH_EKS" = "true" ]; then \
        curl -sL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_${TARGETARCH}.tar.gz" | tar xz -C /tmp && \
        mv /tmp/eksctl /usr/bin && \
        chmod +x /usr/bin/eksctl && \
        apk add --update --no-cache python3 && \
        python3 -m ensurepip && \
        pip3 install --upgrade pip && \
        pip3 install awscli && \
        pip3 cache purge && \
        authenticator=$(curl -fs https://api.github.com/repos/kubernetes-sigs/aws-iam-authenticator/releases/latest | jq --raw-output '.name' | sed 's/^v//') && \
        curl -fL https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${authenticator}/aws-iam-authenticator_${authenticator}_linux_${TARGETARCH} -o /usr/bin/aws-iam-authenticator && \
        chmod +x /usr/bin/aws-iam-authenticator; \
    fi

# Install kubeseal
RUN curl -L https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-${TARGETARCH}.tar.gz -o - | tar xz -C /usr/bin/ && \
    chmod +x /usr/bin/kubeseal

ENV ENV=/root/.ashrc
COPY ashrc /root/.ashrc

ENV BUILD_TIME=${BUILD_TIME}

WORKDIR /apps
