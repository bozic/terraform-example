# Azure Resource Group Module

Manages an Azure Resource Group with support for the create-or-query pattern.

## Usage

### Create a new Resource Group

```hcl
module "resource_group" {
  source = "./azure-resource-group"

  resource_group_name = "my-resource-group"
  location            = "westeurope"
  tags = {
    environment = "production"
  }
}
```

### Query an existing Resource Group

```hcl
module "resource_group" {
  source = "./azure-resource-group"

  resource_group_create = false
  resource_group_name   = "existing-resource-group"
  location              = "westeurope"
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
