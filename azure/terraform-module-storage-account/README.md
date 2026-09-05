# Azure Storage Account Module

Creates or queries an Azure Storage Account, creates zero or more blob containers, optionally generates an account SAS token, and assigns Azure RBAC roles at the account or container scope.

## Usage

### Storage Account with Containers

```hcl
module "storage_account" {
  source = "./azure-storage-account"

  storage_account_name = "examplestorageaccount"
  resource_group_name  = "example-resources"
  location             = "westeurope"

  containers = {
    uploads = {
      container_access_type = "private"
    }
    public = {
      container_access_type = "blob"
    }
  }
}
```

### SAS and RBAC

```hcl
data "azurerm_client_config" "current" {}

module "storage_account" {
  source = "./azure-storage-account"

  storage_account_name = "examplestorageaccount"
  resource_group_name  = "example-resources"
  location             = "westeurope"

  sas = {
    start  = "2026-01-01T00:00:00Z"
    expiry = "2027-01-01T00:00:00Z"
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
      delete  = true
      list    = true
      add     = false
      create  = true
      update  = true
      process = false
      tag     = false
      filter  = false
    }
  }

  rbac_role_assignments = {
    blob_contributor = {
      principal_id         = data.azurerm_client_config.current.object_id
      role_definition_name = "Storage Blob Data Contributor"
    }
  }
}
```

Set `scope` to a container name to assign a role to that container instead of the whole Storage Account. The `sas`, access key, and connection string outputs are marked sensitive. When querying an existing account, set `storage_account_create = false` and provide its `resource_group_name`.

Storage Accounts created by this module deny public network traffic by default and allow trusted Azure services through the network rules.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
