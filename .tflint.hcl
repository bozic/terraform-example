plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# Azure — add provider-specific plugins below as new providers are onboarded
plugin "azurerm" {
  enabled = true
  version = "0.28.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# plugin "aws" {
#   enabled = true
#   version = "0.36.0"
#   source  = "github.com/terraform-linters/tflint-ruleset-aws"
# }
