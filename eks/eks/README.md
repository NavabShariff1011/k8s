# setup cluster eks using eksctl 
```
eksctl create cluster -f cluster.yaml
```
# nginx ingress-controller
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```
```
helm repo update
```

```
helm pull ingress-nginx --repo https://kubernetes.github.io/ingress-nginx
```

now change some values in values.yaml 

**controller.service.annotations**
```
annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
    service.beta.kubernetes.io/aws-load-balancer-subnets: 

```

```
helm install nginx --namespace ingress-nginx --create-namespace .
```

# cert-manager
```
helm repo add jetstack https://charts.jetstack.io --force-update
```
```
helm repo update
```
```
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.14.3 --set installCRDs=true
```

**cluster issuer**
```
cat > cluster-issuer.yaml <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
    name: letsencrypt-prod
spec:
  acme:
    email: navab.shariff1011@gmail.com
    preferredChain: ""
    privateKeySecretRef:
      name: letsencrypt-production
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - http01:
        ingress:
          class: nginx
EOF
```
```
k apply -f cluster-issuer.yaml
```    
