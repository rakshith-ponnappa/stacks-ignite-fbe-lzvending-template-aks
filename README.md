# fb-lzvending-aks-template

Last validated against code on 2026-03-30.

## Overview

Source template repository for AKS-based workload landing zones. `fb-lzvending` uses this repository to scaffold new `fb-app-*` repositories for AKS workload subscriptions.

This repository is a source template, so placeholder tokens such as `__APPLICATION_NAME__` are expected and must remain unresolved here.

Owner: Platform Engineering Team

## What this template deploys

Core landing-zone resources:
- Resource groups, spoke networking, AKS, Log Analytics, optional ACR, optional Front Door, optional PostgreSQL, and optional Key Vault.
- `azurerm_virtual_network_dns_servers.vnet_dns` configured from identity remote state.
- Optional ingress patterns for Private Link Service or AGIC.
- A clear split between core landing-zone resources and downstream application-layer onboarding handled after scaffolding.

Root modules from `deploy/core/terraform/main.tf`:
- `az_naming`: `git::https://github.com/FiveB-Infra/fb-naming.git?ref=v2026.03.17.11`
- `tagging`: `git::https://github.com/FiveB-Infra/fb-tagging.git?ref=v2026.03.10.4`
- `remote_state`: `../../shared/modules/tf_remote_state`
- `resource_groups`: `Azure/avm-res-resources-resourcegroup/azurerm` with version `0.2.1` and `for_each = var.component_names`
- `network`: `./modules/az_network`
- `acr`: `./modules/az_acr`
- `frontdoor`: `./modules/az_frontdoor`
- `aks`: `./modules/az_aks`
- `log_analytics`: `./modules/az_log_analytics`
- `demo_app`: `./modules/demo_app`
- `postgresql`: `./modules/az_postgresql` with `count = var.create_postgresql ? 1 : 0`
- `keyvault`: `../../shared/modules/az_keyvault` with `count = var.create_keyvault ? 1 : 0`

External module dependencies used inside local modules:
- `az_network` uses `git::https://github.com/Ensono/terraform-azurerm-evm-vnet?ref=0.2.3`
- `az_aks` uses `Azure/aks/azurerm` version `11.3.0`
- `az_acr` uses `Azure/avm-res-containerregistry-registry/azurerm` version `0.4.0`
- `az_frontdoor` uses `claranet/cdn-frontdoor/azurerm` version `8.1.0`
- `az_postgresql` uses `Azure/avm-res-dbforpostgresql-flexibleserver/azurerm` version `0.1.4`
- `az_keyvault` (shared) uses `Azure/avm-res-keyvault-vault/azurerm` version `0.10.2`
- `data.tf` uses `claranet/regions/azurerm` version `8.0.2` for region short-name lookup

Feature-flagged root resources in `deploy/core/terraform/main.tf`:
- `azapi_resource_action.agw_network_isolation` and `time_sleep.wait_for_agw_network_isolation`
- `azurerm_public_ip.agic`, `azurerm_application_gateway.agic`, and AGIC role assignments
- `kubectl_manifest.nginx_internal_pls`, `time_sleep.wait_for_pls`, and `terraform_data.pls_cleanup`
- `time_sleep.wait_2_minutes` and `time_sleep.wait_for_rbac` for RBAC propagation
- `removed` block for `module.ingress` — cleanly destroys the previous Helm-based NGINX release from state (replaced by App Routing add-on)

Core root outputs from `deploy/core/terraform/outputs.tf`:
- `frontdoor_profile_id`, `frontdoor_profile_name`, `frontdoor_resource_group_name`, `frontdoor_sku_name`
- `pls_name`, `aks_resource_group_name`, `aks_cluster_name`, `aks_cluster_id`, `private_endpoint_subnet_id`
- `postgresql_server_id`, `postgresql_server_name`, `postgresql_server_fqdn`, `postgresql_connection_info`
- `keyvault_id`, `keyvault_name`, `keyvault_uri`
- `acr_name`, `acr_id`, `acr_login_server`, `acr_resource_group_name`
- `agic_enabled`, `ingress_application_gateway`, `application_gateway_id`, `application_gateway_name`, `application_gateway_public_ip`

Core versus app-layer boundary:
- This template deploys the shared AKS landing-zone substrate.
- Application-specific resources such as namespaces, PostgreSQL databases, Front Door endpoints, WAF policies, and workload identity bindings are scaffolded later through `fb-app-orchestration`.

## Pipeline behavior

Workflow files:
- `.github/workflows/pipeline.yml` for the core landing-zone pipeline.
- `.github/workflows/pipeline-app-orchestration.yml` for application-layer scaffolding.

Core workflow triggers:
- Push to `main` with path filters covering workflow, build, and `deploy/core` changes.
- Pull requests to `main` with the same path filters.
- Manual dispatch with `terraform_action`, `deploy_dev`, `deploy_uat`, `deploy_prd`, `deploy_eastus2`, and `deploy_centralus`.

Core promotion order:
- Two parallel region chains after the shared build and cost-estimate stages:
  ```
  BUILD → COST-ESTIMATE ─┬→ DEV-EASTUS2 → UAT-EASTUS2 → PRD-EASTUS2 ─┬→ FINAL
                          └→ DEV-CENTRALUS → UAT-CENTRALUS → PRD-CENTRALUS ─┘
  ```
- Pull requests run the DEV East US 2 path only.
- Central US is opt-in through workflow-dispatch toggles.

App-orchestration dispatch inputs:
- `application_name`, `application_name_short`, `action`, `ingress_type`

Reusable workflow dependencies:
- `FiveB-Infra/fb-pipeline-templates/.github/workflows/template_build.yml@main`
- `FiveB-Infra/fb-pipeline-templates/.github/workflows/template_cost_estimate.yml@main`
- `FiveB-Infra/fb-pipeline-templates/.github/workflows/template_deploy.yml@main`
- `FiveB-Infra/fb-pipeline-templates/.github/workflows/template_final.yml@main`
- `FiveB-Infra/fb-app-orchestration/.github/workflows/template_app_orchestration.yml@main`

Cross-repo workflow dependencies:
- The deploy template requires self-hosted runners in the target region's runner group (for example `azure-eastus2-intg-runner-grp`, `azure-centralus-intg-runner-grp`). These runners must be provisioned before deployment can succeed.
- Every core deploy job passes `state_lockdown_all_location_storage_accounts: true` to `template_deploy.yml`, so the shared post-apply lockdown step targets both regional state storage accounts for the active environment.
- The final template reads `${{ vars.TAG_FORMAT }}` from the consumer repository. This variable must be set as a repository variable.

Cost-estimation coverage:
- Estimated regions: `dev_eastus2`, `uat_eastus2`, `prd_eastus2`
- Cost estimation covers East US 2 only. Central US deployments are not included in cost estimates.

### Toolchain Versions

| Tool | Version | Source |
|---|---|---|
| Container image | `ensono/eir-infrastructure:1.1.285` | Pipeline templates |
| Terraform | `1.13.3` (constraint `>= 1.13, < 2`) | `.terraform-version`, `versions.tf` |
| taskctl | `1.7.5` | `common_pipeline_variables.yml` |
| tflint plugin `azurerm` | `0.29.0` | `.tflint.hcl` |
| tflint plugin `terraform` | `0.13.0` | `.tflint.hcl` |
| pre-commit-hooks | `v6.0.0` | `.pre-commit-config.yaml` |
| pre-commit-terraform | `v1.100.1` | `.pre-commit-config.yaml` |
| checkov (pre-commit) | `3.2.472` | `.pre-commit-config.yaml` |
| commitlint | `v9.22.0` | `.pre-commit-config.yaml` |

## Inputs

Root Terraform variables from `deploy/core/terraform/variables.tf`:
- Baseline landing-zone variables: `lz_short_code`, `component_names`, `azure_location`, `environment`, `azure_resource_group_management_lock_level`, `vnet_address_space`, `vnet_subnets`, `vnet_nsg_rules`
- Tagging variables: `ProductDomain`, `Application`, `ApplicationCode`, `Environment`, `Role`, `Criticality`, `CostCode`, `Owner`, `CreatedOn`, `CreatedBy`, `Monitoring`
- ACR and paired-region variables: `create_acr_registry`, `acr_sku`, `acr_public_network_access_enabled`, `acr_retention_policy_enabled`, `acr_retention_policy_in_days`, `acr_default_retention_policy_in_days`, `acr_geo_redundant_regions`, `acr_network_rule_set`, `create_acr_secondary_pe`, `private_link_dns_zones`, `paired_region_private_dns_zone_resource_group_name`, `paired_region_pe_subnet_name`, `paired_region_vnet_name`, `paired_region_vnet_resource_group_name`
- Front Door and monitoring variables: `create_frontdoor`, `frontdoor_sku_name`, `frontdoor_response_timeout_seconds`, `frontdoor_logs_destinations_ids`, `availability_zones`, `log_analytics_sku`, `log_analytics_retention_in_days`, `log_analytics_daily_quota_gb`, `log_analytics_internet_ingestion_enabled`
- AKS and network variables: `usr_np_min_count`, `usr_np_max_count`, `usr_np_node_count`, `sys_np_min_count`, `sys_np_max_count`, `sys_np_node_count`, `usr_np_node_vm_size`, `sys_np_node_vm_size`, `aks_azure_policy_enabled`, `aks_role_based_access_control_enabled`, `aks_azure_rbac_enabled`, `aks_private_cluster_public_fqdn_enabled`, `aks_api_server_authorized_ip_ranges`, `create_aks_user_identity`, `workload_identity_enabled`, `only_critical_addons_enabled`, `vnet_routes`, `service_cidr`, `dns_service_ip`
- Ingress and demo-app variables: `enable_private_link_ingress`, `ingress_subnet_name`, `ingress_private_endpoint`, `enable_agic`, `enable_agw_private_only`, `agic_subnet_name`, `agic_zones`, `agic_enable_private_frontend`, `agic_private_ip_address`, `deploy_demo_app`, `demo_app_hostname`, `aks_aad_server_app_id`, `azure_spn_client_secret`
- PostgreSQL and Key Vault variables: `create_postgresql`, `postgresql_admin_group_object_id`, `postgresql_admin_group_name`, `postgresql_admin_principal_type`, `postgresql_sku_name`, `postgresql_storage_mb`, `postgresql_version`, `postgresql_backup_retention_days`, `postgresql_geo_redundant_backup_enabled`, `postgresql_high_availability`, `postgresql_availability_zone`, `create_keyvault`, `keyvault_sku`, `keyvault_purge_protection_enabled`, `keyvault_soft_delete_retention_days`, `keyvault_enabled_for_deployment`, `keyvault_enabled_for_disk_encryption`, `keyvault_enabled_for_template_deployment`

File-based inputs:
- `deploy/core/terraform/terraform.tfvars`
- `deploy/core/terraform/workspace_variables/{env}_{region}_terraform.tfvars.json`
- `build/gha/pipelines/core/templates/variables/common_pipeline_variables.yml`
- `build/gha/pipelines/shared/templates/variables/{env}_{region}_pipeline_variables.yml`

Required GitHub repository variables visible in workflow files:
- `ARM_CLIENT_ID` — service principal client ID for Azure authentication
- `ARM_SUBSCRIPTION_ID` — target Azure subscription ID for deployment
- `ARM_TENANT_ID` — Azure AD tenant ID for authentication
- `SUBSCRIPTION_ALIAS_NAME` — logical subscription alias used by pipeline variable resolution and state-key derivation

Required GitHub repository secrets visible in workflow files:
- `ARM_CLIENT_SECRET` — service principal client secret for Azure authentication
- `INFRACOST_API_KEY` — API key for Infracost cloud pricing lookups
- `REPO_ACCESS_APP_PRIVATE_KEY` — GitHub App private key used to mint a token for cross-repo checkout of `fb-pipeline-templates`
- `REPO_WORKFLOW_APP_PRIVATE_KEY` — GitHub App private key used to mint a write token for app-orchestration PR creation

Required GitHub environment variables inherited from `template_deploy.yml` and the state-lockdown flow:
- `STATE_STORAGE_ACCOUNT_NAME_EUS2` — East US 2 Terraform state storage account name for the target environment; used for backend init fallback and multi-account state lockdown.
- `STATE_STORAGE_ACCOUNT_NAME_CUS` — Central US Terraform state storage account name for the target environment; used for multi-account state lockdown even when only the East US 2 path runs.

Workflow permissions visible in workflow files:
- Core pipeline: `contents: write` (git tagging), `pull-requests: write` (cost/plan comments), `issues: write` (Infracost issue comments), `actions: write` (deploy job approval interaction)
- App orchestration: `contents: write` (branch push), `pull-requests: write` (PR creation)

## Notes

Root providers from `deploy/core/terraform/versions.tf`:
- `azurerm` from `hashicorp/azurerm` with version `~> 4.62.0`
- `azuread` from `hashicorp/azuread` with version `~> 3.0`
- `null` from `hashicorp/null` with version `~> 3.2.4`
- `kubernetes` from `hashicorp/kubernetes` with version `~> 2.35`
- `kubectl` from `gavinbunney/kubectl` with version `~> 1.19`
- `time` from `hashicorp/time` with version `~> 0.11`
- `azapi` from `Azure/azapi` with version `~> 2.0`

Indirect providers (declared only in sub-modules, not in root `versions.tf`):
- `random` from `hashicorp/random` with version `~> 3.8.1` (used in `./modules/az_network`)

Terraform runtime:
- Terraform version constraint is `>= 1.13, < 2`.
- Backend type is `azurerm` with `use_azuread_auth = true`.

Remote-state dependencies:
- Connectivity remote state provides `virtual_hub_resource_id`, `subscription_id`, and `private_dns_zones_resource_group_name`.
- Identity remote state provides `domain_controller_private_ips`.
- Management remote state provides AMPLS outputs (`azure_monitor_private_link_scope_id`, `azure_monitor_private_link_scope_name`) so the workload LAW can be linked into the shared monitoring scope.

Feature waits and conditional guards:
- `time_sleep.wait_for_agw_network_isolation` waits 300 seconds when `enable_agw_private_only` is true.
- `time_sleep.wait_for_dns_zone_rbac` (in `./modules/az_aks`) waits 90 seconds for Private DNS Zone Contributor and Network Contributor role propagation before AKS cluster creation.
- `time_sleep.wait_2_minutes` waits 120 seconds and `time_sleep.wait_for_rbac` waits 60 seconds for RBAC propagation after AKS creation.
- `time_sleep.wait_for_pls` waits 120 seconds when `enable_private_link_ingress` is true.
- `terraform_data.pls_cleanup` handles destroy-time cleanup for Private Link Service resources. The destroy provisioner runs `az network private-link-service delete` and waits 60 seconds for Azure to release internal LB references.

Ingress patterns:
- `enable_private_link_ingress = true` enables the internal NGINX plus Private Link Service pattern.
- `enable_agic = true` enables the AGIC brown-field Application Gateway pattern.
- `enable_agw_private_only = true` layers on the Application Gateway network-isolation feature registration flow.

Identity and RBAC resources created by Terraform:
- `azurerm_user_assigned_identity.aks_identity` — AKS control-plane user-assigned managed identity (in `./modules/az_aks`).
- `azurerm_role_assignment.aks_private_dns_zone` — Private DNS Zone Contributor on the AKS API private DNS zone (in `./modules/az_aks`).
- `azurerm_role_assignment.aks_user_id_network_contributor` — Network Contributor at subscription scope for the AKS user-assigned identity (in `./modules/az_aks`).
- `azurerm_role_assignment.aks_identity_cluster_admin_role` — Azure Kubernetes Service RBAC Cluster Admin assigned to the deploying service principal (in `./modules/az_aks`).
- `azurerm_role_assignment.aks_nodepool_network_contributor` — Network Contributor at subscription scope for the AKS agent pool managed identity (in `./modules/az_aks`).
- `azurerm_role_assignment.agic_appgw_contributor` — Contributor on the Application Gateway (root `main.tf`, when `enable_agic` is true).
- `azurerm_role_assignment.agic_rg_reader` — Reader on the AKS resource group (root `main.tf`, when `enable_agic` is true).
- `azurerm_role_assignment.agic_vnet_network_contributor` — Network Contributor on the VNet (root `main.tf`, when `enable_agic` is true).

AKS cluster security posture:
- Private cluster (`private_cluster_enabled = true`) — API server is only accessible via private endpoint.
- Local accounts disabled (`local_account_disabled = true`) — forces Entra ID authentication; no local kubeconfig.
- Host encryption enabled (`host_encryption_enabled = true`) on both system and user node pools.
- User-defined routing (`net_profile_outbound_type = "userDefinedRouting"`) — all egress routed through spoke UDR (typically via NVA/firewall).
- System node pool tainted with `CriticalAddonsOnly` (when `only_critical_addons_enabled = true`) — user workloads only schedule on the user node pool.
- Workload identity enabled for pod-level Entra ID integration.
- OIDC issuer enabled for federated credential flows.

Operational caveats:
- `__APPLICATION_NAME__` tokens must remain unresolved in this template repository.
- AGIC role assignments stay at the root level to avoid conflicts with upstream module behavior.
- Application-layer resources are intentionally deferred to `fb-app-orchestration`.
- All pipeline jobs have a `github.run_number != 1` guard that skips the very first workflow run, preventing execution on initial repository creation.

### Checkov Suppressions

Global suppressions in `.checkov.yaml` (24 total):
- `CKV_TF_1`: Module sources use git tags rather than commit hashes (project convention).
- `CKV_GHA_7`: Workflow dispatch inputs are required for parameterized deployment.
- `CKV2_GHA_1`: Top-level workflow permissions are declared explicitly.
- `CKV_AZURE_109`: Key Vault firewall false positive (private endpoints used).
- `CKV_AZURE_35`, `CKV_AZURE_36`, `CKV_AZURE_244`, `CKV2_AZURE_38`, `CKV_AZURE_33`: Azure AVM storage module false positives.
- `CKV_AZURE_163`, `CKV_AZURE_164`, `CKV_AZURE_165`, `CKV_AZURE_166`, `CKV_AZURE_233`, `CKV_AZURE_237`: ACR Premium SKU checks not applicable for template defaults.
- `CKV_AZURE_116`, `CKV_AZURE_168`, `CKV_AZURE_170`: AKS external module checks.
- `CKV_AZURE_226`, `CKV_AZURE_227`, `CKV_AZURE_232`: AKS monitoring and security checks.
- `CKV_AZURE_218`: Placeholder HTTP listener — AGIC manages real listeners.
- `CKV_AZURE_217`: Placeholder HTTP listener — AGIC manages HTTPS.
- `CKV_AZURE_120`: WAF enforced at Front Door, not AGIC App GW.

### State Backend

Backend uses `azurerm` with `use_azuread_auth = true`. Storage account and resource group are injected at runtime through pipeline variables.

This template also opts into post-apply backend lockdown through `TFSTATE_LOCKDOWN_ENABLED: "true"` and `TFSTATE_DNS_LOOKUP_SUBSCRIPTION: "fb-connectivity-1"` in `build/gha/pipelines/core/templates/variables/common_pipeline_variables.yml`. Because the core workflow sets `state_lockdown_all_location_storage_accounts: true`, generated repos must provide `STATE_STORAGE_ACCOUNT_NAME_EUS2` and `STATE_STORAGE_ACCOUNT_NAME_CUS` in each GitHub Environment so both regional backend accounts can be locked down after apply.

### Workspace Variable Convention

Workspace variable files under `deploy/core/terraform/workspace_variables/`:
- `{env}_{region}_terraform.tfvars.json` (6 files: dev/uat/prd × eastus2/centralus)

## Validation and Testing

Repository validation entry points:
- `pre-commit run --all-files`
- `terraform fmt -check -recursive`
- `terraform init && terraform validate`
- `tflint --init && tflint`
- `checkov -d . --config-file .checkov.yaml`
- `terraform-docs .`

The BUILD job runs the shared validation pipeline from `fb-pipeline-templates`.

## Usage Guide

1. Run the `fb-lzvending` provisioning workflow and choose `fb-lzvending-aks-template`.
2. Update `deploy/core/terraform/workspace_variables/` with the allocated environment and region CIDRs, AKS service CIDR, DNS service IP, and subnet definitions.
3. Configure the required GitHub repository variables and secrets.
4. Trigger the core deployment workflow by pushing to `main` or by using manual dispatch.
5. After the landing zone exists, use the app-orchestration workflow to scaffold application-layer directories and pipelines.
6. For local work, load `envvars.ps1` and run the normal Terraform and taskctl commands from the repo.

### Local Development

`envvars.ps1` provides dynamic environment setup for local Terraform runs. It prompts for region (default `eastus2`) and loads the matching pipeline variable files:

```powershell
. .\envvars.ps1
```

## Maintenance and Update Guide

- Keep the six workspace variable files aligned when subnet or CIDR layouts change.
- Keep the `fb-naming` and `fb-tagging` source refs aligned with derived repositories.
- Revalidate generated repositories after template changes so the output contract remains compatible with `fb-app-orchestration`.
- Treat AKS version, node-pool, ingress, and feature-flag changes as coordinated updates because several conditional resources depend on them.
- Do not replace `__APPLICATION_NAME__` inside this source template repository.

## Ownership and Escalation

Owner: Platform Engineering Team
