variable "region" {
  type = string
}

# variable "replica_region" {
#   type = string
# }

variable "environment" {
  type = string
}

# variable "organization_id" {
#   type = string
# }

# variable "billing_account_id" {
#   type = string
# }

variable "db_machine_type" {
  type = string
}

variable "db_disk_size" {
  type    = number
  default = "100"
}

variable "subnet_cidr_range" {
  type = string
}

variable "cluster_master_cidr_range" {
  type = string
}

variable "cluster_pods_cidr_range" {
  type = string
}

variable "cluster_pods_range_name" {
  type    = string
  default = "cluster-pods-cidr-range"
}

variable "cluster_services_cidr_range" {
  type = string
}

variable "cluster_service_range_name" {
  type    = string
  default = "cluster-services-cidr-range"
}

variable "cluster_machine_type" {
  type = string
}

variable "min_node_count" {
  type = number
}

variable "max_node_count" {
  type = number
}

variable "source_project_id" {}
variable "target_project_id" {}