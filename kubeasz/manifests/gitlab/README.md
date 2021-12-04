# gitlab及其组件安装
> 执行以下命令创建创建资源和pod
```
kubectl -n gitlab-ns apply -f postgresql/postgresql-pvc.yml  
kubectl -n gitlab-ns apply -f postgresql/postgresql-deployment.yml  
kubectl -n gitlab-ns apply -f redis/redis-deployment.yml  
kubectl -n gitlab-ns apply -f gitlab-ce/gitlab-pvc.yml  
kubectl -n gitlab-ns apply -f gitlab-ce/gitlab-secret.yml
kubectl -n gitlab-ns apply -f gitlab-ce/gitlab-deployment.yml  
kubectl -n gitlab-ns apply -f gitlab-ce/gitlab-ingress.yml
kubectl -n gitlab-ns apply -f gitlab/gitlab-runner/docker-pvc.yml  
kubectl -n gitlab-ns apply -f gitlab/gitlab-runner/docker-deployment.yml  
kubectl -n gitlab-ns apply -f gitlab/gitlab-runner/share-pvc.yml  
kubectl -n gitlab-ns apply -f gitlab/gitlab-runner/share-deployment.yml
```
# gitlab-runner配置
> 进入docker-runner pod进行配置
```
# gitlab-ci-multi-runner register
# 注册完成后，修改/etc/gitlab-runner/config.toml内容，pod中没有vim，因为这个目录已经做了持久化，在nfs机器上修改

# https://docs.gitlab.com/runner/executors

vim /etc/gitlab-runner/config.toml
concurrent = 30
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "gitlab-runner-docker"
  url = "http://git.example.com"
  token = "9VhG5fpBhJsLzsDVJdJp"
  executor = "kubernetes"
  [runners.kubernetes]
    namespace = "gitlab-ns"
    image = "harbor.example.com/library/docker:stable"
    helper_image = "harbor.example.com/library/gitlab-runner-helper:x86_64-9fc34d48-pwsh"
    privileged = true
    [[runners.kubernetes.volumes.pvc]]
      name = "gitlab-runner-docker"
      mount_path = "/mnt"
```
> 在gitlab页面，编辑docker-runner的选项：1
```
#                   Active  √ Paused Runners don't accept new jobs
#                Protected     This runner will only run on pipelines triggered on protected branches
#        Run untagged jobs     Indicates whether this runner can pick jobs without tags
# Lock to current projects     When a runner is locked, it cannot be assigned to other projects
```

> 进入share-runner pod进行配置
```
# https://docs.gitlab.com/runner/executors
# gitlab-ci-multi-runner register
# 注册完成后，修改/etc/gitlab-runner/config.toml内容，pod中没有vim，因为这个目录已经做了持久化，在nfs机器上修改

vim /etc/gitlab-runner/config.toml
concurrent = 30
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "gitlab-runner-share"
  url = "http://git.example.com"
  token = "9VhG5fpBhJsLzsDVJdJp"
  executor = "kubernetes"
  [runners.kubernetes]
    namespace = "gitlab-ns"
    image = "harbor.example.com/library/busybox:v1.29.2"
    helper_image = "harbor.example.com/library/gitlab-runner-helper:x86_64-9fc34d48-pwsh"
    privileged = false
    [[runners.kubernetes.volumes.pvc]]
      name = "gitlab-runner-share"
      mount_path = "/mnt"

```
> 在gitlab页面，编辑share-runner的选项：1、3
```

#                   Active  √ Paused Runners don't accept new jobs
#                Protected     This runner will only run on pipelines triggered on protected branches
#        Run untagged jobs  √ Indicates whether this runner can pick jobs without tags
# Lock to current projects     When a runner is locked, it cannot be assigned to other projects
```

# 增加gitlab在k8s的内部解析
```
# kubectl -n kube-system get configmaps coredns  -o yaml
# kubectl -n kube-system edit configmaps coredns
apiVersion: v1
data:
  Corefile: |
    .:53 {
        errors
        health
        ready
        log
        rewrite stop {
          name regex git.example.com gitlab.gitlab-ns.svc.cluster.local
          answer name gitlab.gitlab-ns.svc.cluster.local git.example.com
        }

        kubernetes cluster.local in-addr.arpa ip6.arpa {

          pods verified
          fallthrough in-addr.arpa ip6.arpa
        }
        autopath @kubernetes
        prometheus :9153
        forward . /etc/resolv.conf
        cache 30
        loop
        reload
        loadbalance
    }
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system

# kubectl -n kube-system delete pod coredns-5787695b7f-jfp7n
# kubectl -n kube-system get pods -w
# kubectl -n kube-system logs coredns-5787695b7f-qfnfn
```
# 增加ssh端口转发
```
# 注意配置此转发前，需要将对应NODE的本身ssh连接端口作一下修改，以防后面登陆不了该机器
iptables -t nat -A PREROUTING -d 192.168.33.100 -p tcp --dport 2222 -j DNAT --to-destination 10.68.218.106:22

# 删除上面创建的这一条规则，将-A换成-D即可

iptables -t nat  -nvL PREROUTING
```
