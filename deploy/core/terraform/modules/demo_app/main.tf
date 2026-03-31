# =============================================================================
# Demo Application - Kubernetes Resources (for PLS testing)
# Using traefik/whoami - a simple container that returns request info
# Perfect for testing Front Door -> PLS -> Ingress connectivity
# =============================================================================

# Namespace for demo application
resource "kubernetes_namespace" "demo_app" {
  count = var.deploy ? 1 : 0

  metadata {
    name = "demo-app"
    labels = {
      app         = "demo-app"
      environment = var.environment
      managed-by  = "terraform"
    }
  }
}

# Demo Application Deployment - using traefik/whoami
resource "kubernetes_deployment" "demo_app" {
  count = var.deploy ? 1 : 0

  metadata {
    name      = "demo-app"
    namespace = kubernetes_namespace.demo_app[0].metadata[0].name
    labels = {
      app = "demo-app"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "demo-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "demo-app"
        }
      }

      spec {
        automount_service_account_token = false

        security_context {
          run_as_non_root = true
          run_as_user     = 10001
          run_as_group    = 10001
          fs_group        = 10001
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        container {
          name              = "demo-app"
          image             = "traefik/whoami:v1.10@sha256:1699d99cb4b9acc17f74ca670b3d8d0b7ba27c948b3445f0593b58ebece92f04"
          image_pull_policy = "Always"

          # whoami listens on port 80 by default, override to 8080 for non-root
          args = ["--port", "8080"]

          port {
            container_port = 8080
          }

          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem  = true
            capabilities {
              drop = ["ALL"]
            }
          }

          resources {
            requests = {
              cpu    = "10m"
              memory = "16Mi"
            }
            limits = {
              cpu    = "50m"
              memory = "32Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 8080
            }
            initial_delay_seconds = 3
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 8080
            }
            initial_delay_seconds = 3
            period_seconds        = 5
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.demo_app]
}

# Service for Demo Application
resource "kubernetes_service" "demo_app" {
  count = var.deploy ? 1 : 0

  metadata {
    name      = "demo-app-svc"
    namespace = kubernetes_namespace.demo_app[0].metadata[0].name
    labels = {
      app = "demo-app"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      app = "demo-app"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 8080
      protocol    = "TCP"
    }
  }
}

# Ingress using App Routing with internal PLS class for Front Door connectivity
resource "kubernetes_ingress_v1" "demo_app" {
  count = var.deploy_ingress ? 1 : 0

  metadata {
    name      = "demo-app-ingress"
    namespace = kubernetes_namespace.demo_app[0].metadata[0].name
    annotations = {
      "kubernetes.azure.com/use-internal-lb" = "true"
    }
  }

  spec {
    ingress_class_name = "nginx-internal-pls"

    rule {
      # Host must match what Front Door sends in origin_host_header
      host = var.hostname
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.demo_app[0].metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_service.demo_app]
}

# Network Policy for demo application
resource "kubernetes_network_policy" "demo_app" {
  count = var.deploy ? 1 : 0

  metadata {
    name      = "demo-app-network-policy"
    namespace = kubernetes_namespace.demo_app[0].metadata[0].name
  }

  spec {
    pod_selector {
      match_labels = {
        app = "demo-app"
      }
    }

    policy_types = ["Ingress", "Egress"]

    ingress {
      from {
        namespace_selector {}
      }
      ports {
        port     = "8080"
        protocol = "TCP"
      }
    }

    egress {
      to {
        namespace_selector {}
      }
      ports {
        port     = "53"
        protocol = "TCP"
      }
      ports {
        port     = "53"
        protocol = "UDP"
      }
    }
  }
}
