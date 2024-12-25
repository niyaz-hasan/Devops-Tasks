# Devops-Tasks
Project 

# Bash script 
bash script to loop on all databases into a postgresql server
then backup and compress each database into a different directory
then upload it to a S3 bucket

# Terraform 
1 VPC
○ 3 public subnets
○ 3 private subnets
○ 3 Private routing tables
○ 1 public routing table
○ 1 internet gateway
○ 3 Elastic IP's for NAT Gateways
○ 3 NAT GateWays


# Dockerfile
Save the below python “3.7” script into a “.py” file then create a
Dockerfile that will create a docker image for it which will run the
python script into CMD command.

# kubernetes manifest files deployment and service Expose to application
Create a yaml file which will be used to deploy that docker image
onto a Kubernetes cluster “any cluster a minikube will be good”.
Create a service file for it which should expose the port into the
python script.

# HPA 
Create a horizontal pod autoscaler file for it.

# Jenkins pipeline and Gitops deployment to cluster 
○ Clone the repository you’ve created.
○ Build the docker image and give it a build number tag.
○ Push it on any docker registry.
○ Deploy it on a kubernetes cluster.