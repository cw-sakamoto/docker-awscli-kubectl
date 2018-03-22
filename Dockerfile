FROM gcr.io/google_containers/ubuntu-slim:0.14
MAINTAINER Ryo Sakamoto <sakamoto@chatwork.com>

# Disable prompts from apt.
ENV DEBIAN_FRONTEND noninteractive

ENV AWS_CLI_VERSION 1.14.55
ENV KUBE_VERSION 1.8.4
ENV TINI_VERSION 0.17.0

ARG pip_installer="https://bootstrap.pypa.io/get-pip.py"

# install kubectl, awscli
RUN apt-get update -y \
 && apt-get install -y --no-install-recommends ca-certificates jq curl wget python3-pip python3-setuptools \
 && pip3 install --upgrade pip \
 && pip3 install --upgrade awscli==${AWS_CLI_VERSION} \
 && curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl \
 && chmod +x kubectl \
 && mv kubectl /usr/local/bin/kubectl \
 && rm -rf /var/lib/apt/lists/*

# Add Tini
# https://github.com/krallin/tini#using-tini
ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]
