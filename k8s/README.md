# Solution - Task 1

## Prerequisites
   1. [terraform](https://www.terraform.io/downloads.html) >= v0.12.5
   2. GCP account

## Description
This is a guideline on how to build `Kubernetes` cluster using `Terraform`.

## Run Terraform 
It is very simple to build `Kubernetes` cluster using terraform, only need to run 2 commands:
```
terraform plan
terraform apply
```
To destroy environment run this command:
```
terraform destroy
```
That's it. Isn't simple right?

## Automation
To ease deployment, provided a shell script that can automate deployment and setup on Kubernetes.
```
sh auto-deployment.sh
```

## Provider
In order to have a configuration that can connect to Google Cloud Platform project, need IAM that has edit role (basic role) on project or can use a service account that configure project.
This also needs some values to defined; project, region, version, and credential (saved in local machine).

## Cluster
To setup `Kubernetes` cluster on GCP, `Terraform` source code can be found on github or `Terraform` registry that people share their configuration.
`Terraform` module can be used to simplify work.
Module that needs to use in this project:
  1. Network
  2. Cluster
  3. Node Pool

### Network
This section is to set network value that can overwrite default values from module.

Configuration:
1. network_name         : The name of the network
2. subnetwork_name      : Name for the subnetwork
3. region               : Region to use
4. enable_flow_logs     : To turn on flow logs
5. subnetwork_range     : CIDR for subnetwork nodes
6. subnetwork_pods      : Secondary CIDR for pods
7. subnetwork_services  : Secondary CIDR for services

### Cluster
This section is to set cluster value that can overwrite default values from module.

Configuration:
1. region                           : Region to use
2. name                             : The name of cluster
3. project                          : Project name
4. network_name                     : The name of the network
5. nodes_subnetwork_name            : The name of an existing google_compute_subnetwork resource where cluster compute instances are launched
6. kubernetes_version               : The kubernetes version for the nodes in the pool. This should match the Kubernetes version of the GKE cluster
7. pods_secondary_ip_range_name     : The name of an existing network secondary IP range to be used for pods
8. services_secondary_ip_range_name : The name of an existing network secondary IP range to be used for services

### Node Pool
Configuration:
1. name : The name of the node pool
2. region : Region to use
3. gke_cluster_name : The name of the GKE cluster to bind this node pool
4. machine_type : The machine type of nodes in the pool (Default = n1-standard-4)
5. min_node_count : Minimum number of nodes for autoscaling, per availability zone
6. max_node_count : Maximum number of nodes for autoscaling, per availability zone
7. kubernetes_version : The kubernetes version for the nodes in the pool. This should match the Kubernetes version of the GKE cluster

## Limitations
* Because this project using module from github, probably that some resources are not suit with requirements in real project.
* Storing `Terraform` state file in local might have a chance that state file can be lost, so configuration will be meshed up.

## Improvements
As mentioned above about limitations of this application, those can be improved by adding some other setup or configuration.
* Create own module so project can reduce resources are suit with requirements.
* Better to store `Terraform` state file in cloud storage, it can prevent losing state file if there are many people working on the same project.