# ci.cmake

CMake script that to builds, tests, and packages the current working directory in Release mode. Also defines `$CACHE{CI_BUILD_VERSION}` as the output of `git describe --tags --always`.

## Features

- `ci.cmake` - entrypoint

## Usage

`cmake -P ci.cmake`

### Artifacts

`build/packages` - CPack install directory

### Dependencies

- Git

## Versioning

- Tags - stable SemVer
- `main` branch - unstable
