provider "google" {
  project = "global-matrix-374023"
  region  = "us-west2"
}
provider "google-beta" {
  # project = "global-matrix-374023"
  # region  = "us-west2"
}
resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  provider            = google-beta
  project             = "global-matrix-374023" #google_project.environment_applications_project.project_id
  name                = "apthub-${var.environment}-db-${random_id.db_name_suffix.hex}"
  region              = "us-central1"
  database_version    = "POSTGRES_14"
  root_password       = "newnew"
  deletion_protection = false
  settings {
    tier      = var.db_machine_type
    disk_size = var.db_disk_size

    # authorized_gae_applications = []
    availability_type = "REGIONAL"
    backup_configuration {
      binary_log_enabled = false
      enabled            = true
      start_time         = "23:00"
    }

    # database_flags {
    #   name  = "redis_cache_enabled"
    #   value = "on"
    # }

    # database_flags {
    #   name  = "redis_cache_host"
    #   value = google_redis_instance.example_redis.host
    # }

    # database_flags {
    #   name  = "redis_cache_port"
    #   value = google_redis_instance.example_redis.port
    # }

    ip_configuration {
      require_ssl  = true
      ipv4_enabled = true
      #   private_network = "paypay-vpc" 
    }
    user_labels = {
      # "cloudsql-proxy-instances" = "example_redis:${google_redis_instance.example_redis.host}"
    }
    # location_preference {
    #   follow_gae_application = true
    # }

  }

  depends_on = [
    # google_redis_instance.cache,
    # google_project_service.application_project_sql_admin,
    # google_project_service.application_project_service_networking
  ]
}

resource "google_sql_database" "apthub" {
  project  = "global-matrix-374023"
  name     = "apthub"
  instance = google_sql_database_instance.instance.name
}

## This section creates the read replica in another region

resource "google_sql_database_instance" "instance_replica" {
  name                 = "apthub-${var.environment}-db-${random_id.db_name_suffix.hex}-replica"
  region               = "us-west1"
  database_version     = "POSTGRES_14"
  master_instance_name = google_sql_database_instance.instance.name
  deletion_protection  = false


  settings {
    tier      = var.db_machine_type
    disk_size = var.db_disk_size

    ip_configuration {
      require_ssl  = true
      ipv4_enabled = true
      #   private_network = "paypay-vpc" #data.terraform_remote_state.apthub_common.outputs.global_network_id
    }
    # user_labels = {
    #   "cloudsql-proxy-instances" = "my-redis-instance:${google_redis_instance.redis_instance.host}"
    # }
  }

  #   replica_configuration {
  #     master_instance_name = google_sql_database_instance.instance.name
  #     write_capacity = 0
  #   }

  depends_on = [
    google_sql_database_instance.instance
    #     google_project_service.application_project_sql_admin,
    #     google_project_service.application_project_service_networking
  ]
}
## Failover instance in another region
# resource "google_sql_database_instance" "secondary_instance" {
#   project             = "global-matrix-374023" #google_project.environment_applications_project.project_id
#   name                = "apthub-${var.environment}-db-${random_id.db_name_suffix.hex}-failover"
#   region              = "us-east4"
#   database_version    = "POSTGRES_14"
#   root_password       = "newnew"
#   deletion_protection = false
#   settings {
#     tier      = var.db_machine_type
#     disk_size = var.db_disk_size

#     # authorized_gae_applications = []
#     availability_type = "REGIONAL"
#     backup_configuration {
#       binary_log_enabled = false
#       enabled            = true
#       start_time         = "23:00"
#     }

#     # database_flags {
#     #   name  = "hot_standby"
#     #   value = "on"
#     # }
#     # database_flags {
#     #   name  = "max_connections"
#     #   value = "100"
#     # }

#     ip_configuration {
#       require_ssl  = true
#       ipv4_enabled = true
#       #   private_network = "paypay-vpc" 
#     }
#     # location_preference {
#     #   follow_gae_application = true
#     # }
#   }

#   depends_on = [
#     # google_project_service.application_project_sql_admin,
#     # google_project_service.application_project_service_networking
#   ]
# }

# resource "google_sql_database" "apthub-failover_instance" {
#   project  = "global-matrix-374023"
#   name     = "apthub"
#   instance = google_sql_database_instance.secondary_instance.name
# }

# ## This section creates the read replica in another region

# resource "google_sql_database_instance" "failover_instance_replica" {
#   name                 = "apthub-${var.environment}-db-${random_id.db_name_suffix.hex}-failover-replica"
#   region               = "us-west1"
#   database_version     = "POSTGRES_14"
#   master_instance_name = google_sql_database_instance.secondary_instance.name
#   deletion_protection  = false


#   settings {
#     tier      = var.db_machine_type
#     disk_size = var.db_disk_size

#     ip_configuration {
#       require_ssl  = true
#       ipv4_enabled = true
#       #   private_network = "paypay-vpc" #data.terraform_remote_state.apthub_common.outputs.global_network_id
#     }
#   }

#   #   replica_configuration {
#   #     master_instance_name = google_sql_database_instance.instance.name
#   #     write_capacity = 0
#   #   }

#   depends_on = [
#     google_sql_database_instance.secondary_instance
#     #     google_project_service.application_project_sql_admin,
#     #     google_project_service.application_project_service_networking
#   ]
# }
