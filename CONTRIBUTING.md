# Contributing

## Module Structure

Each module lives under its provider directory:

```
{provider}/terraform-module-{name}/
  {provider}-{name}/            # Implementation
    main.tf
    variables.tf
    outputs.tf
    terraform.tf
    override.template           # Optional: build-time variable substitution
  examples/{use-case}/          # At least one example required
    main.tf
    provider.tf
    terraform.tf
    variables.tf
    tests/
      {module}-{use-case}.tftest.hcl
  CHANGELOG.md
  README.md
  VERSION                       # Semver: MAJOR.MINOR.PATCH
  LEVEL                         # Dependency level: 0, 1, or 2
```

Provider directories currently in use: `azure/`. Future providers (e.g. `aws/`, `gcp/`) follow the same layout.

## Adding a New Module

1. Create the directory structure above under the appropriate provider directory
2. Set `LEVEL` to `0` unless the module depends on other modules in this repo
3. Pin the provider version in `terraform.tf` (e.g. `hashicorp/azurerm ~> 4.24.0`)
4. Write at least one example with a test
5. Set `VERSION` to `1.0.0`
6. Create `CHANGELOG.md` with the initial entry
7. Run `terraform fmt -recursive` and `pre-commit run --all-files`

## Adding a New Provider

1. Create a top-level directory named after the provider (e.g. `aws/`)
2. Add the provider's TFLint ruleset to `.tflint.hcl`
3. Update the CI workflow path triggers in `.github/workflows/terraform-ci.yml` to include the new provider directory
4. Update the matrix generation script to detect modules under the new directory
5. Add any provider-specific authentication variables to the GitHub environments

## Versioning

Update the `VERSION` file on every change:
- **MAJOR**: Breaking changes to variables or outputs
- **MINOR**: New backward-compatible features
- **PATCH**: Bug fixes

Bump the version once per branch — the first commit on a feature branch updates `VERSION` and `CHANGELOG.md`, and subsequent commits on that branch do not increment it further.

## Testing

- Use Terraform Test Framework (`.tftest.hcl`)
- Place tests in `examples/{use-case}/tests/`
- Tests must pass `terraform test` with `apply` command
- Run locally: `terraform -chdir="{provider}/terraform-module-{name}/examples/{use-case}" init && terraform -chdir="{provider}/terraform-module-{name}/examples/{use-case}" test`

## Code Style

Follow the [official Terraform style guide](https://developer.hashicorp.com/terraform/language/style). Run `terraform fmt` before committing.
