# Changelog

All notable changes to this module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-09-05

### Added

- Initial Azure Storage Account module release.
- Create-or-query support for storage accounts.
- Zero-to-many blob container support.
- Sensitive access key, connection string, and optional account SAS outputs.
- Optional SAS expiration policy and RBAC role assignments.

### Changed

- Secure storage defaults now enable infrastructure encryption, geo-redundant replication,
  storage analytics logging, and deny-by-default network rules.
