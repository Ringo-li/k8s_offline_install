创建数据库命名空间及权限
```
bash kube_config_generate.sh database https://192.168.33.61:6443
kubectl -n database apply -f .
kubectl exec -it   -n database mysql-0  -- /bin/bash
create database meiduo charset=utf8;
create user ringo identified by '123456';
grant all on meiduo.* to 'ringo'@'%';
flush privileges;
```
