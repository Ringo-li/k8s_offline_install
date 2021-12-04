在代码仓库变量配置里面配置如下变量值  
```
Type           Key                      Value                    State        Masked
Variable   DOCKER_USER                 admin                   下面都关闭   下面都关闭
Variable   DOCKER_PASS                 Harbor12345
Variable   REGISTRY_URL                harbor.example.com
Variable   REGISTRY_NS                 product
File       KUBE_CONFIG_TEST            k8s相关config配置文件内容
```
一键生成k8s相关config配置文件内容  
```
bash kube_config_generate.sh flask-test https://192.168.33.100:6443
```
