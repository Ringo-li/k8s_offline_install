#!/bin/bash
file_list=(
README.md
ansible_v2.9.9_install
hosts
k8s_offline_install.sh
#kubeasz/ansible.cfg
#kubeasz/ezctl
#kubeasz/ezdown
#vagrant
#kubeasz/bin/
kubeasz/down/
kubeasz/clusters/
kubeasz/example/
kubeasz/manifests/
kubeasz/playbooks/
kubeasz/roles/
kubeasz/tools/
)

for file in ${file_list[*]}
do
  echo "${file} finished "
  rsync -az --progress /mnt/z/one-key-install-k8s/${file} /mnt/d/share/one-key-install-k8s/${file} --delete
done
#rsync -rv /mnt/z/one-key-install-k8s/vagrant/ /mnt/d/share/test/ --delete
