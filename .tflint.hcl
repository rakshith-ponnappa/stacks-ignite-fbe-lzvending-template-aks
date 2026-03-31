plugin "azurerm" {
    enabled = true
    version = "0.29.0"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

plugin "terraform" {
    enabled = true
    version = "0.13.0"
    source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

rule "terraform_standard_module_structure" {
  enabled = false
}

rule "terraform_required_version" {
  enabled = false
}

# Disable rules that flag pre-existing issues in shared modules
rule "terraform_unused_declarations" {
  enabled = false
}

rule "terraform_deprecated_index" {
  enabled = false
}

rule "terraform_required_providers" {
  enabled = false
}
