# ci.cmake

CMake script that calls CMake/CTest/CPack to build, test, and package the current working directory. Builds all targets in release most with cache variable `CI_BUILD_VERSION` set to the output of `git describe --tags --always`.

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
