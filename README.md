[TOC] 

# 说明
k8s全离线安装

## 安装包更新时间
2021-11-19  
请获取最新安装包

## 项目地址
[https://github.com/Ringo-li/k8s_offline_install](https://github.com/Ringo-li/k8s_offline_install)  
  
基于以下原作者安装过程稍作改动：  
[https://github.com/bogeit/LearnK8s/blob/main/k8s_install_new.sh](https://github.com/bogeit/LearnK8s/blob/main/k8s_install_new.sh)
[https://github.com/easzlab/kubeasz/blob/master/docs/setup/offline_install.md](https://github.com/easzlab/kubeasz/blob/master/docs/setup/offline_install.md)  

## 版本信息
docker： 19.03.14  
kubernetes: v1.20.2  
flannel: v0.13.0-amd64  
ingress: aliyun-ingress-controller:v0.30.0.2-9597b3685-aliyun

# 前期准备
## 1.服务器
4台以上安装centos7.8-2003 或者 7.9-2009的机器，其他未作测试
## 2.获取安装包
[https://cloud.189.cn/t/VZVri27J73u2(访问码:9wka)](https://cloud.189.cn/t/VZVri27J73u2) 

# 安装过程
1.解压软件包one-key-install-k8s.tar.gz  
2.编辑host文件，设置主机信息  
3.执行bash k8s_offline_install.sh 主机root密码 集群名称  

# 安装验证
## 1.集群验证
```
kubectl get pod -A
```
查看pod是否都正常

## 2.查看ingress等服务是否正常发布dashboard服务
在同网段PC的hosts文件中加一行：  
hosts中ex_lb设置的EX_APISERVER_VIP kubernetes.example.com  
用浏览器访问  
https://kubernetes.example.com  
获取token：
```
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user-token | awk '{print $1}')
```

# 单独执行
安装出错单步安装时使用，需要一点ansible基础

```
cd /etc/kubeasz
ansible-playbook -i "clusters/k8s-cluster/hosts" -e "@clusters/k8s-cluster/config.yml" "playbooks/04.kube-master.yml" --start-at-task="准备kubelet 证书签名请求"
```
