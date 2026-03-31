variable "nginx_ingress_namespace" {
  description = "Namespace where the managed NGINX ingress controller runs."
  type        = string
  default     = "app-routing-system"
}
