locals {
  # Default response timeout
  response_timeout = var.frontdoor_response_timeout_seconds > 0 ? var.frontdoor_response_timeout_seconds : 120

  frontdoor_name_suffix = terraform.workspace != "prd" ? terraform.workspace : ""
}
