#!/bin/bash
sed -i  /^PasswordAuthentication/s/no/yes/ /etc/ssh/sshd_config
systemctl restart sshd

# # yum -y install nfs-utils

# # 创建NFS挂载目录
# mkdir /nfs_dir
# chown nobody.nobody /nfs_dir

# # 修改NFS-SERVER配置
# echo '/nfs_dir *(rw,sync,no_root_squash)' > /etc/exports

# # 重启服务
# systemctl restart rpcbind.service
# systemctl restart nfs-utils.service 
# systemctl restart nfs-server.service 

# # 增加NFS-SERVER开机自启动
# systemctl enable nfs-server.service 

# # 验证NFS-SERVER是否能正常访问
# # showmount -e 127.0.0.1                 
# # Export list for 10.0.1.201:
# # /nfs_dir *

# rsync -Pa --delete  /ansible/one-key-install-k8s/kubeasz/roles/ /etc/kubeasz/roles/
# rsync -Pa  /ansible/one-key-install-k8s/kubeasz/playbooks/ /etc/kubeasz/playbooks/
# rsync -Pa  /ansible/one-key-install-k8s/kubeasz/down/ /etc/kubeasz/down/
# rsync -Pa  /ansible/one-key-install-k8s/kubeasz/manifests/ /etc/kubeasz/manifests/
# cat /ansible/one-key-install-k8s/hosts > /etc/kubeasz/clusters/k8s-cluster/hosts