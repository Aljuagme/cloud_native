#!/bin/bash
#create a k3d cluster with definition file
k3d cluster create --config ./k3d/k3d-local-dev-cluster.yaml
#create namespace for the argocd installation
kubectl create namespace argocd
# install argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


# the argo-cd intial admin password can be read with the following command:
# printf "\n"
# echo "PASSWORD FOR ARGOCD: "
# kubectl get secret argocd-initial-admin-secret -n argocd -o yaml
# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
# printf "\n\n"
# OR
# replace it with your own fixed admin password
# https://www.browserling.com/tools/bcrypt
# bcrypt("jku-argocd-pass")=$2a$10$6kh.T.ID.kokPshuMstv/uKos5scx34pRrq6a6XSlYPmbS90z2O1C
kubectl -n argocd patch secret argocd-secret -p '{"stringData": {"admin.password": "$2a$10$ScYm8RbiBJNV2s6AkLI70Osfz9Jf/S7mWjz/maTM.8vEA2Gg04diG","admin.passwordMtime": "'$(date +%FT%T%Z)'"}}'

# start the GitOps with creation of argo-cd app
kubectl -n argocd apply -f ./argo-cd/argo-cd-app.yaml

# Uncomment if new
# sleep 200 
# Forward
kubectl port-forward -n argocd svc/argocd-server 8080:443 &

kubectl port-forward deployment/python-deployment -n python-namespace 5000:5000

