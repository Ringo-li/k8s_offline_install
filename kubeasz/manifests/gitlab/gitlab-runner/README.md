# gitlab-runner
## docker-runner
> docker-runner是用作打包和上传镜像使用  
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

## share-runner
> share-runner是供所有项目CI/CD调度使用  
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