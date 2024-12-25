# EKS - Horizontal Pod Autoscaling (HPA)

## Step-01: Introduction
- What is Horizontal Pod Autoscaling?
- How HPA Works?
- How HPA configured?

## Step-02: Install Metrics Server
```
# Verify if Metrics Server already Installed
kubectl -n kube-system get deployment/metrics-server

# Install Metrics Server
kubectl apply -f kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.7.2/components.yaml

# Verify
kubectl get deployment metrics-server -n kube-system
```

## Step-03: Review Deploy our Application
```
# Deploy
kubectl apply -f kubernetes-manifests-files/

# List Pods, Deploy & Service
kubectl get pod,svc,deploy

# Access Application (Only if our Cluster is Public Subnet)
kubectl get nodes -o wide
http://<Worker-Node-Public-IP>:31231
```


## Step-04:  Verify how HPA is working
```

# List all HPA
kubectl get hpa

# List specific HPA
kubectl get hpa test-python-hpa

# Describe HPA
kubectl describe hpa/test-python-hpa 

# List Pods
kubectl get pods
```

## Step-05: Cooldown / Scaledown
- Default cooldown period is 5 minutes. 
- Once CPU utilization of pods is less than 50%, it will starting terminating pods and will reach to minimum 1 pod as configured.


## Step-06: Clean-Up
```
# Delete HPA
kubectl delete hpa hpa-demo-deployment

# Delete Deployment & Service
kubectl delete -f kubernetes-manifests-files/ 
```

