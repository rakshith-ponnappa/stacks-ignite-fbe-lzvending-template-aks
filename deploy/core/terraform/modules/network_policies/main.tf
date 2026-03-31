# =============================================================================
# Cluster-Wide Network Policies
# System-level policies applied once at the cluster level.
# Per-namespace default-deny and app-specific rules are managed by the
# app orchestration template — not here.
# =============================================================================

# -----------------------------------------------------------------------------
# NGINX Ingress Namespace — Default Deny Egress
# Lock down app-routing-system so it cannot reach arbitrary destinations.
# -----------------------------------------------------------------------------
resource "kubernetes_network_policy" "nginx_default_deny_egress" {
  metadata {
    name      = "default-deny-egress"
    namespace = var.nginx_ingress_namespace
  }

  spec {
    pod_selector {}
    policy_types = ["Egress"]
  }
}

# -----------------------------------------------------------------------------
# NGINX Ingress Namespace — Allow DNS
# NGINX needs DNS resolution via CoreDNS in kube-system.
# -----------------------------------------------------------------------------
resource "kubernetes_network_policy" "nginx_allow_dns" {
  metadata {
    name      = "allow-dns"
    namespace = var.nginx_ingress_namespace
  }

  spec {
    pod_selector {}
    policy_types = ["Egress"]

    egress {
      to {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "kube-system"
          }
        }
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

# -----------------------------------------------------------------------------
# NGINX Ingress Namespace — Allow Egress to Application Pods
# Uses a label selector so any namespace that opts in (via the orchestration
# template label "network-policy/ingress-from-nginx: true") is reachable.
# No explicit namespace list required.
# -----------------------------------------------------------------------------
resource "kubernetes_network_policy" "nginx_allow_egress_to_apps" {
  metadata {
    name      = "allow-egress-to-apps"
    namespace = var.nginx_ingress_namespace
  }

  spec {
    pod_selector {}
    policy_types = ["Egress"]

    egress {
      to {
        namespace_selector {
          match_labels = {
            "network-policy/ingress-from-nginx" = "true"
          }
        }
      }
    }
  }
}
