# Azure Storage Account Module

Deploys an Azure Storage Account and zero or more blob containers. The module also supports shared access keys, optional account SAS tokens, and RBAC assignments at the storage-account, container, or arbitrary Azure scope.

## Usage

```hcl
module "storage_account" {
  source = "./azure-storage-account"

  storage_account_name = "examplestorageacct"
  resource_group_name  = "example-resources"
  location             = "westeurope"

  network_rules = {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }

  containers = {
    private = {}
    public = {
      container_access_type = "blob"
    }
  }

  sas_policy = {
    expiration_period = "7.00:00:00"
    expiration_action = "Block"
  }

  sas = {
    start  = "2026-01-01T00:00:00Z"
    expiry = "2026-12-31T23:59:59Z"

    resource_types = {
      service   = false
      container = true
      object    = true
    }

    services = {
      blob  = true
      queue = false
      table = false
      file  = false
    }

    permissions = {
      read    = true
      write   = true
      delete  = false
      list    = true
      add     = true
      create  = true
      update  = true
      process = false
      tag     = false
      filter  = false
    }
  }

  role_assignments = {
    workload_reader = {
      principal_id         = "00000000-0000-0000-0000-000000000000"
      role_definition_name = "Storage Blob Data Reader"
      principal_type       = "ServicePrincipal"
    }
  }
}
```

Set `storage_account_create = false` to query an existing storage account by name and resource group. Set `container_name` in a role assignment to scope it to one of the module-managed containers; omit it to scope the assignment to the storage account, or set `scope` for an arbitrary Azure scope.

Access keys, connection strings, and the optional SAS token are sensitive outputs. When `shared_access_key_enabled = false`, configure the `azurerm` provider with `storage_use_azuread = true` so that Azure AD authentication can manage supported data-plane resources.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
