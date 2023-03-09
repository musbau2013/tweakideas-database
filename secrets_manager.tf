# data "google_secret_manager_secret_version" "admin-password" {
#   for_each = toset(["test_a","test_b"])
#   project = "american-xpress"
#   # provider = google-beta
#   secret   = each.key
#   # version  = "1"
# }
# resource "google_secret_manager_secret "new-key" {

# }

# # output "domain-admin-password" {
# #   value = toset([ for admin-password in 
# #     data.google_secret_manager_secret_version.admin-password : admin-password.secret_data])
# #   sensitive = true
# # }