# # # Create a Kubernetes cluster using the GKE module
# # module "gke_cluster" {
# #   source = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
# #   # ...
# # }

# # Deploy your application to Kubernetes using a Deployment or StatefulSet

# # Expose your application using a Kubernetes service of type NodePort
# resource "kubernetes_service" "app" {
#   metadata {
#     name = "my-app"
#   }
#   spec {
#     selector = {
#       app = "my-app"
#     }
#     port {
#       name        = "http"
#       port        = 80
#       target_port = 8080
#     }
#     type = "NodePort"
#   }
# }

# # Create a Google Cloud Load Balancer
# resource "google_compute_forwarding_rule" "lb" {
#   name                  = "my-lb"
#   ip_address            = "AUTO"
#   load_balancing_scheme = "EXTERNAL"
#   port_range            = "80-80"
#   target                = module.gke_cluster.instance_group_url

#   depends_on = [
#     module.gke_cluster,
#   ]
# }

# resource "google_compute_global_address" "lb_ip" {
#   name = "my-lb-ip"
# }

# resource "google_compute_global_forwarding_rule" "lb" {
#   name                  = "my-lb"
#   ip_address            = google_compute_global_address.lb_ip.address
#   load_balancing_scheme = "EXTERNAL"
#   port_range            = "80-80"
#   target                = google_compute_forwarding_rule.lb.self_link
# }

# # Update the Kubernetes service to use the external IP address of the Google Cloud Load Balancer as its endpoint
# resource "kubernetes_service" "app" {
#   metadata {
#     name = "my-app"
#   }
#   spec {
#     selector = {
#       app = "my-app"
#     }
#     port {
#       name        = "http"
#       port        = 80
#       target_port = 8080
#     }
#     type = "LoadBalancer"

#     # Use the external IP address of the Google Cloud Load Balancer as the endpoint
#     load_balancer_ip = google_compute_global_address.lb_ip.address
#   }
# }
