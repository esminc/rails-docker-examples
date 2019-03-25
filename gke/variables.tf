variable "project" {}
variable "environment" {
  default = "rails-docker-examples"
}

variable "region" {
  default = "asia-northeast1"
}

variable "zone" {
  default = "asia-northeast1-a"
}

variable "private_subnet_cider" {
  default = "10.127.0.0/20"
}

variable "k8s_cluster_cider" {
  default = "10.60.0.0/14"
}

variable "k8s_services_cider" {
  default = "10.7.0.0/20"
}

variable "k8s_node_machine_type" {
  default = "n1-standard-1"
}

variable "k8s_node_count" {
  default = 1
}

variable "db_machine_type" {
  default = "db-f1-micro"
}
