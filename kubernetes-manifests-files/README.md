# kubernetes manifest files 

# I've updated the YAML file to deploy a Python-based application and expose its port through the service

# To create the deployment manifest in k8s cluster 
# This YAML file includes a Deployment to create and manage your Docker container replicas and a Service to expose the application to the network

# deployment 

kubectl apply -f deployment.yml 


# Service 

kubectl apply -f service.yml 
 
