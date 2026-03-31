locals {
  # Always pass an object so the upstream module can evaluate count at plan time.
  # The workspace ID/name values can remain unknown until apply.
  log_analytics_workspace = {
    id   = var.log_analytics_workspace_id
    name = var.log_analytics_workspace_name
  }

  rbac_aad_admin_group_object_ids = concat(
    coalesce(var.rbac_aad_admin_group_object_ids, []),
    [var.current_client_object_id]
  )
}
