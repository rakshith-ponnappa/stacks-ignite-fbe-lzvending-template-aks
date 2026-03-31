variable "deploy" {
  description = "Whether to deploy the demo application"
  type        = bool
  default     = false
}

variable "deploy_ingress" {
  description = "Whether to deploy the ingress resource (requires PLS ingress controller)"
  type        = bool
  default     = false
}

variable "hostname" {
  description = "Hostname for the demo app ingress, must match Front Door origin_host_header"
  type        = string
  default     = "demo-app.internal.fivebelow.com"
}

variable "environment" {
  description = "Environment name (workspace) for labelling"
  type        = string
}
