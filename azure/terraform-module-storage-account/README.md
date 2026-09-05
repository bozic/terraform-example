# Azure Storage Account Module

Manages an Azure Storage Account with support for the create-or-query pattern, deploying zero-to-many Storage Containers, RBAC role assignments, and Shared Access Signature (SAS) token generation.

## Usage

### Create a new Storage Account

```hcl
module "storage_account" {
  source = "./azure-storage-account"

  storage_account_name = "mystorageaccount"
  resource_group_name  = "my-resource-group"
  location             = "westeurope"

  tags = {
    environment = "production"
  }
}
```

### Query an existing Storage Account

```hcl
module "storage_account" {
  source = "./azure-storage-account"

  storage_account_create = false
  storage_account_name   = "existingstorageaccount"
  resource_group_name    = "my-resource-group"
  location               = "westeurope"
}
```

### Deploy containers and RBAC role assignments

```hcl
module "storage_account" {
  source = "./azure-storage-account"

  storage_account_name = "mystorageaccount"
  resource_group_name  = "my-resource-group"
  location             = "westeurope"

  containers = {
    data = {
      container_access_type = "private"
    }
    logs = {
      container_access_type = "blob"
      metadata = {
        purpose = "logs"
      }
    }
  }

  role_assignments = {
    reader = {
      role_definition_name = "Storage Blob Data Reader"
      principal_id         = "00000000-0000-0000-0000-000000000000"
    }
  }
}
```

### Generate a SAS token

```hcl
module "storage_account" {
  source = "./azure-storage-account"

  storage_account_name = "mystorageaccount"
  resource_group_name  = "my-resource-group"
  location             = "westeurope"

  sas_token_enabled = true
  sas = {
    start  = "2024-01-01T00:00:00Z"
    expiry = "2030-01-01T00:00:00Z"

    resource_types = {
      service   = true
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
      update  = false
      process = false
      tag     = false
      filter  = false
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
