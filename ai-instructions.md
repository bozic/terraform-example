## Project Overview

Multi-provider Terraform modules monorepo. Modules are organized by cloud provider under top-level directories (`azure/`, `aws/`, etc.). Each provider directory contains modules following the same structure and conventions.

Currently active providers:
- **Azure** — `azurerm` provider (~> 4.24.0)

## Repository Layout

```
{provider}/
  terraform-module-{name}/
    {provider}-{name}/          # Module implementation (main.tf, variables.tf, outputs.tf, terraform.tf)
    examples/{use-case}/        # Example configurations (also used as test roots)
      tests/*.tftest.hcl        # Terraform native test files
    CHANGELOG.md                # Keep a Changelog format
    VERSION                     # Semantic version (plain text, e.g. "2.0.4")
    LEVEL                       # Dependency level: 0, 1, or 2
    README.md
```

## Build Dependency Levels

Modules declare a `LEVEL` file (0, 1, or 2) indicating dependency order. CI builds levels sequentially — all LEVEL 0 modules complete before LEVEL 1 starts.

- **LEVEL 0**: Standalone modules (no cross-module dependencies)
- **LEVEL 1**: Depends on LEVEL 0 modules
- **LEVEL 2**: Depends on LEVEL 0 and LEVEL 1 modules

## Provider Resource Documentation

Use terraform-mcp server to generate provider resource documentation. If you can't find relevant documentation for a resource or data source, check the `tf-docs/` folder in this repo.

The `tf-docs/` folder at the repo root contains one Markdown file per provider resource type (e.g. `tf-docs/azurerm_virtual_network.md`). **Always read the relevant file(s) from `tf-docs/` before writing or modifying any resource or data source block** — these files are the authoritative reference for supported arguments, attribute names, and constraints for this repo's pinned provider versions.

## Coding Conventions

- Follow the official Terraform style guide: https://developer.hashicorp.com/terraform/language/style
- Use `terraform fmt` formatting
- Pin Terraform to version `1.16.0` in every `terraform` block: `required_version = "= 1.16.0"`
- Pin provider versions in every module's `terraform.tf` (e.g. `~> 4.24.0` for azurerm)
- Use the create-or-query pattern: a `var.*_create` boolean with `count` on both `resource` and `data` blocks
- Mark sensitive outputs explicitly with `sensitive = true`
- Use `dynamic` blocks for optional nested configuration
- Use `locals` for computed values and conditional logic
- Check every resource's mandatory parameters and expose them as mandatory module input variables.
- Check parameter dependencies. When setting one parameter requires other parameters, enforce that relationship with module variable `validation` blocks.

## Variable Naming

- Resource-specific prefix: `var.resource_group_name`, `var.vnet_name`
- Boolean create flags: `var.{resource}_create` (default `true`)
- Tags: `var.tags` (type `map(string)`, default `null`)

## Module Patterns

- **Create-or-query pattern**: Most modules use a `var.*_create` boolean — `true` creates the resource, `false` queries an existing one via `data` source. This is implemented with `count` on both the resource and data source blocks.
- **Override templates**: Some modules have `override.template` files with `$VAR_NAME` placeholders that `envsubst` expands to `override.tf` at build time (used for environment-specific module source URLs).

## Versioning

- Update `VERSION` file (semver) and `CHANGELOG.md` on every module change
- **MAJOR**: Breaking changes to variables or outputs interface
- **MINOR**: New features, backward-compatible
- **PATCH**: Bug fixes only
- Bump the version once per branch — the first commit on a feature branch updates `VERSION`, and subsequent commits on that branch do not increment it further

## Testing

- Use Terraform Test Framework (`.tftest.hcl` files)
- Run `tflint` before committing Terraform changes
- Place tests in `examples/{use-case}/tests/`
- Configure the `azurerm` provider in example roots and `.tftest.hcl` files with `features {}` only; it reads authentication from the `ARM_*` environment variables supplied by CI.
- Never declare Terraform variables solely to pass Azure credentials to tests, and never reference credential variables in `.tftest.hcl` files. Do not use `TF_VAR_*` for provider credentials because Terraform parses their values as HCL expressions.
- In GitHub Actions, map the `snapshot` environment values to `ARM_SUBSCRIPTION_ID`, `ARM_CLIENT_ID`, and `ARM_TENANT_ID`, and map the `AZURE_CLIENT_SECRET` secret to `ARM_CLIENT_SECRET`.
- Do not generate `override.tf` from a module's `override.template` while running example tests. The module is a child module during those tests, so any backend block it declares is ignored.
- Assert on resource attributes after `apply`
- Test file naming: `{module-name}-{use-case}.tftest.hcl`
- At least two tests per module are required; additional tests per use-case. Mandatory use cases are public and private (if applicable). Optional use cases are for additional features or configurations (deploy additional resources as part of the test, do not reuse other modules in test). For naming, always generate radnomized resource names in tests to avoid collisions. Use `random_pet` or `random_string` resources for this purpose.

## Security

- Never include credentials or secrets in Terraform files
- Use `override.template` with `$VAR_NAME` placeholders for environment-specific values
- Security scanners (Trivy, Checkov) run in CI — ensure modules pass both
- **Trivy** (`trivy.yaml`): Config scanning, skips `examples/`, fails on fixable vulnerabilities. Fix only critical issues that are found by Trivy
- **Checkov** (`.checkov.yml`): Terraform framework, skips `examples/`

## CI/CD Pipeline

Three-stage GitHub Actions pipeline:
1. **Security check**: Trivy + Checkov scanners
2. **Matrix generation**: Detects changed modules via `git diff`, groups by LEVEL
3. **Build & test**: Tests each changed module's examples, requires approval for deployment

Only modules with changes in the current push/PR are built. The pipeline processes levels sequentially (0 → 1 → 2) to respect inter-module dependencies.
