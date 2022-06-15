## jenkins配置国内源进行插件升级
### 1.进入配置文件目录，两个方法
方法一：  
cd /data/nfs_dir/jenkins-pvc-jenkins-pvc-8da17ed0-03c8-438d-a6f2-b0ae6cdf9eef/
方法二：  
kubectl exec -it jenkins-6cb5b47dcd-hdhpb -n jenkins -- bash
cat var/jenkins_home/updates/
### 2.修改配置文件

cp hudson.model.UpdateCenter.xml hudson.model.UpdateCenter.xml.bak
sed -i 's#updates.jenkins.io#mirrors.aliyun.com/jenkins/updates#g' hudson.model.UpdateCenter.xml
下面几行不需要修改
<!-- 
cp updates/default.json updates/default.json.bak
sed -i 's#https://updates.jenkins.io/download#https://mirrors.aliyun.com/jenkins#g' updates/default.json
sed -i 's#http://www.google.com#https://www.baidu.com#g' updates/default.json 
-->
### 3.初始化密码查看和基本操作：
https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-kubernetes