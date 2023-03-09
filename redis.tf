# # Set up a Redis instance with 3 replicas

resource "google_redis_instance" "cache" {
  name               = "cmek-memory-cache"
  project            = "american-xpress"
  tier               = "STANDARD_HA"
  memory_size_gb     = 5
  read_replicas_mode = "READ_REPLICAS_ENABLED"

  location_id        = "us-west1-a"
  authorized_network = "default"
  replica_count      = 3

  redis_version     = "REDIS_6_X"
  display_name      = "Terraform Test Instance"
  reserved_ip_range = "192.168.0.0/26"

  auth_enabled            = true
  transit_encryption_mode = "SERVER_AUTHENTICATION"

  customer_managed_key = google_kms_crypto_key.redis_key.id

  depends_on = [
    google_kms_crypto_key.redis_key,
  ]


}



resource "google_kms_key_ring" "redis_keyring_1" {
  project = "american-xpress"
  name     = "redis-keyring"

  location = "us-west1"

  depends_on = [
    google_project_service.kms_api,
  ]
}

resource "google_kms_crypto_key" "redis_key" {
  name            = "redis-key_1"
  key_ring        = google_kms_key_ring.redis_keyring_1.id
  rotation_period = "100000s"

  lifecycle {
    prevent_destroy = false
  }
  depends_on = [
  google_kms_key_ring.redis_keyring_1,
  ]
}

resource "google_project_service" "global_project_redis" {
  provider = google-beta

  project = "american-xpress"
  service = "redis.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_project_service" "kms_api" {
  project = "american-xpress"
  service = "cloudkms.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_project_iam_member" "redis_keyring_cryptokey_encrypter_decrypter" {
  project = "american-xpress"
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:service-451326331141@cloud-redis.iam.gserviceaccount.com"

  # The resource parameter is formatted as follows:
  # "//cloudkms.googleapis.com/v1/projects/{project}/locations/{location}/keyRings/{keyring}/cryptoKeys/{cryptokey}"
  # resource = "//${google_kms_crypto_key.redis_key.id}"      #"//cloudkms.googleapis.com/v1/projects/american-xpress/locations/us-west1/keyRings/redis-keyring/cryptoKeys/redis-key_1"
depends_on = [
  google_kms_crypto_key.redis_key,
]
}
