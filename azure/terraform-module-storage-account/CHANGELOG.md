# Changelog

All notable changes to this module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-09-05

### Added

- Initial release of the Azure Storage Account module.
- Create-or-query pattern via `storage_account_create` variable.
- Support for deploying 0:n Storage Containers via the `containers` variable.
- Support for RBAC role assignments against the Storage Account via the `role_assignments` variable.
- Support for generating a Shared Access Signature (SAS) token via `sas_token_enabled` and `sas` variables.
- Support for `network_rules` and `identity` optional blocks. `network_rules` defaults to denying public network access except for trusted Azure services.
- Outputs for `id`, `name`, `primary_blob_endpoint`, `primary_access_key`, `secondary_access_key`, `primary_connection_string`, `identity`, `containers`, `role_assignment_ids`, and `sas_token`.
