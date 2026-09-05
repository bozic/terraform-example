provider "azurerm" {
  features {}
}

run "apply" {
  command = apply

  assert {
    condition     = module.storage_account.id != ""
    error_message = "Storage Account ID must not be empty."
  }

  assert {
    condition     = length(module.storage_account.containers) == 2
    error_message = "Exactly 2 containers should be created."
  }

  assert {
    condition     = module.storage_account.containers["data"].id != ""
    error_message = "The 'data' container ID must not be empty."
  }

  assert {
    condition     = can(regex("^logs-", module.storage_account.containers["logs"].name))
    error_message = "The 'logs' container name must start with 'logs-'."
  }

  assert {
    condition     = length(module.storage_account.role_assignment_ids) == 1
    error_message = "Exactly 1 role assignment should be created."
  }

  assert {
    condition     = module.storage_account.role_assignment_ids["reader"] != ""
    error_message = "The 'reader' role assignment ID must not be empty."
  }

  assert {
    condition     = module.storage_account.sas_token != null && module.storage_account.sas_token != ""
    error_message = "A SAS token must be generated when sas_token_enabled is true."
  }
}
