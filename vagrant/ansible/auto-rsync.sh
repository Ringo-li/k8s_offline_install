#!/bin/bash

rsync -Pa --delete  /ansible/one-key-install-k8s/kubeasz/roles/ /etc/kubeasz/roles/
rsync -Pa  /ansible/one-key-install-k8s/kubeasz/playbooks/ /etc/kubeasz/playbooks/
rsync -Pa  /ansible/one-key-install-k8s/kubeasz/down/ /etc/kubeasz/down/
rsync -Pa  /ansible/one-key-install-k8s/kubeasz/manifests/ /etc/kubeasz/manifests/
cat /ansible/one-key-install-k8s/hosts > /etc/kubeasz/clusters/k8s-cluster/hosts