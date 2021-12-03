module "network" {
  source = "github.com/FairwindsOps/terraform-gcp-vpc-native//default?ref=default-v2.1.0"
  // base network parameters
  network_name     = "kube"
  subnetwork_name  = "kube-subnet"
  region           = "asia-southeast1"
  enable_flow_logs = "false"
  // subnetwork primary and secondary CIDRS for IP aliasing
  subnetwork_range    = "10.40.0.0/16"
  subnetwork_pods     = "10.41.0.0/16"
  subnetwork_services = "10.42.0.0/16"
}

module "cluster" {
  source                           = "github.com/FairwindsOps/terraform-gke//vpc-native?ref=vpc-native-v1.2.0"
  region                           = "asia-southeast1"
  name                             = "gke"
  project                          = "terraform-module-cluster"
  network_name                     = "kube"
  nodes_subnetwork_name            = module.network.subnetwork
  kubernetes_version               = "1.21.5-gke.1302"
  pods_secondary_ip_range_name     = module.network.gke_pods_1
  services_secondary_ip_range_name = module.network.gke_services_1
}

module "node_pool" {
  source             = "github.com/FairwindsOps/terraform-gke//node_pool?ref=node-pool-v3.0.0"
  name               = "gke-node-pool"
  region             = module.cluster.region
  gke_cluster_name   = module.cluster.name
  machine_type       = "n1-standard-1"
  min_node_count     = "1"
  max_node_count     = "2"
  kubernetes_version = module.cluster.kubernetes_version
}