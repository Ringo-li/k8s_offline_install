#!/bin/bash
set -e

BASEDIR=$(pwd)

# 传参检测
[ $# -ne 2 ] && echo -e "Usage: $0 rootpasswd k8s-cluster-name\nExample: bash $0 rootpasswd k8s-cluster\n" && exit 11 

# 变量定义
rootpasswd=$1
clustername=$2

function ansible_install(){
  # tar -xf $BASEDIR/ansible_v2.9.9_install.tar.gz
  cd $BASEDIR/ansible_v2.9.9_install
  bash ansible_v2.9.0_install.sh
}

# 配置互信
function mutual_trust(){
  hosts=$(grep -E  "^\w(\w{1,3}\.){3}\w{1,3}$"  $BASEDIR/hosts  | sort | uniq)
  echo ${hosts}
  for host in ${hosts}
  do
    echo "============ ${host} ===========";
    if [[ ${USER} == 'root' ]];then
        [ ! -f /${USER}/.ssh/id_rsa ] &&\
        ssh-keygen -t rsa -P '' -f /${USER}/.ssh/id_rsa
    else
        [ ! -f /home/${USER}/.ssh/id_rsa ] &&\
        ssh-keygen -t rsa -P '' -f /home/${USER}/.ssh/id_rsa
    fi
    sshpass -p ${rootpasswd} ssh-copy-id -o StrictHostKeyChecking=no ${USER}@${host}
    scp -r $BASEDIR/kubeasz/down/rpm ${USER}@${host}:/var/
  done
}

# 安装k8s集群
function k8s_cluster_install(){
  echo "============ 复制文件... ============ "
  cp -r $BASEDIR/kubeasz /etc/
  echo "============ 生成配置文件 ============ "
  /etc/kubeasz/ezctl new ${clustername}
  sed -i /pass/s/changeme/vagrant/ $BASEDIR/hosts
  cat $BASEDIR/hosts > /etc/kubeasz/clusters/${clustername}/hosts
  # sed -i /basedir/s#/basedir#$BASEDIR# $BASEDIR/kubeasz/roles/prepare/files/local.repo
  echo "============ 开始安装集群 ============ "
  bash /etc/kubeasz/ezctl setup k8s-cluster all
}


function main(){
  ansible_install
  mutual_trust
  k8s_cluster_install
}

main
