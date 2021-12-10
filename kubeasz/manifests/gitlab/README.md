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
