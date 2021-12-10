#!/bin/bash 
if [ $CANARY_CB -eq 1 ]
then
    cp -arf .project-name-canary.yaml ${namecb}-${CI_COMMIT_TAG}.yaml
    sed -ri "s+CanarylIngressNum+${CanarylIngressNum}+g" ${namecb}-${CI_COMMIT_TAG}.yaml
    sed -ri "s+NomalIngressNum+$(expr 100 - ${CanarylIngressNum})+g" ${namecb}-${CI_COMMIT_TAG}.yaml
else
    cp -arf .project-name.yaml ${namecb}-${CI_COMMIT_TAG}.yaml
fi
sed -ri "s+projectnamecb.example.com+${ingress}+g" ${namecb}-${CI_COMMIT_TAG}.yaml
sed -ri "s+projectnamecb+${namecb}+g" ${namecb}-${CI_COMMIT_TAG}.yaml
sed -ri "s+5000+${svcport}+g" ${namecb}-${CI_COMMIT_TAG}.yaml
sed -ri "s+replicanum+${replicanum}+g" ${namecb}-${CI_COMMIT_TAG}.yaml
sed -ri "s+mytls+${certname}+g" ${namecb}-${CI_COMMIT_TAG}.yaml
sed -ri "s+mytagcb+${CI_COMMIT_TAG}+g" ${namecb}-${CI_COMMIT_TAG}.yaml
sed -ri "s+harbor.example.com/library+${IMG_URL}+g" ${namecb}-${CI_COMMIT_TAG}.yaml
cat ${namecb}-${CI_COMMIT_TAG}.yaml
[ -d ~/.kube ] || mkdir ~/.kube
echo "$KUBE_CONFIG" > ~/.kube/config
if [ $NORMAL_CB -eq 1 ]
then 
    if kubectl get deployments.|grep -w ${namecb}-canary &>/dev/null
    then
        kubectl delete deployments.,svc ${namecb}-canary
    fi
fi
kubectl apply -f ${namecb}-${CI_COMMIT_TAG}.yaml --record
echo
echo
echo "============================================================="
echo "                    Rollback Indx List"
echo "============================================================="
kubectl rollout history deployment ${namecb}|tail -5|awk -F"[ =]+" '{print $1"\t"$5}'|sed '$d'|sed '$d'|sort -r|awk '{print $NF}'|awk '$0=""NR".   "$0'