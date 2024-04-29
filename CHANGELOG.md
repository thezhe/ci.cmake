# Changelog

## v2.0.1 - 2024/04/29

### Changed

- Refactor CPack code

## v2.0.0 - 2024/04/28

### Added

- `thezhe_add_ci`

### Changed

- Name to `add_ci`

### Removed

- `CI_BUILD_VERSION`
- GitHub releases

## v1.0.1 - 2024/01/28

### Fixed

- `CI_BUILD_VERSION` does not include git lightweight tags

## v1.0.0 - 2024/01/27

### Changed

- skip packaging if no `CPackConfig.cmake`
- script-wide namespaced with `ci_` prefix
- cache variables namespaced with `CI_` prefix

### Fixed

- `CI_BUILD_VERSION` cache variable string breaks without git
- dev container startup conflict with `brobeson.vscode-cmake-lint`

## v0.9.0 - 2024/01/14

### Added

- `ci.cmake`
- `test/`
- `.github/workflows/main.yml`
