# Bring up new EKS for mainneet


## Step-1/4: Create a new IAM user


The best practice is create new i am user and then use new i am user access keys to create eks..

`Note:`

Hide this new i am user details , he will be the cluster admin
              
Use `i am roles` and `aws-auth` to give eks access such as `Developer` and `admin` access to  other users in organisation

## Step-2/4: Create New VPC

First you need to create new vpc, for this i am using terraform 

```
cd vpc-network
```


`Note:`

Edit variable.tf according to your requirement

```
terraform init
```

```
terraform plan
```

```
terraform apply --auto-approve
```


## Step-3/4: Create eks

I am using eksctl automation tool to bring up new eks

`Note:`

Edity `cluster.yaml` file according to your requirement

```
eksctl create cluster -f cluster.yaml --profile mainnet
```

## Step-4/4: Install ingress controller and certmanager

### nginx ingress-controller

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```

```
helm repo update
```

```
helm pull ingress-nginx --repo https://kubernetes.github.io/ingress-nginx
```

Now change some values in `values.yaml` 

**controller.service.annotations**

```
annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
    service.beta.kubernetes.io/aws-load-balancer-subnets: <public-subnet-ids>
```


```
helm install nginx --namespace ingress-nginx --create-namespace .
```

### cert-manager

```
helm repo add jetstack https://charts.jetstack.io --force-update
```
```
helm repo update
```
```
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --set installCRDs=true
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