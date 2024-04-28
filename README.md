# add_ci

`thezhe_add_ci` CMake function

## Usage

```CMake
include(FetchContent)
FetchContent_Declare(
    add_ci
    GIT_REPOSITORY https://github.com/thezhe/add_ci.git
    GIT_TAG <hash>
    GIT_SHALLOW TRUE)
FetchContent_MakeAvailable(add_ci)
thezhe_add_ci()
```

## Versioning

- Tags - stable SemVer
- `main` branch - unstable
