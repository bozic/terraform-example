# Azure Key Vault Module

Manages an Azure Key Vault with support for the create-or-query pattern.

## Usage

```hcl
module "key_vault" {
  source = "./azure-key-vault"

  name                = "my-unique-key-vault"
  location            = "westeurope"
  resource_group_name = "my-resource-group"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}
```

Set `key_vault_create = false` to query an existing Key Vault instead of creating one.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
