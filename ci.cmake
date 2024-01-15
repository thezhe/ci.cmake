#[[
Builds all CMake targets in `./CMakeLists.txt` in Release mode.
Also test and package if applicable.
Hereinafter, "test" or "package" implies the step exists.

    cmake -P <path-to-ci.cmake>

Package Output: build/package
Cache Variables: CI_BUILD_VERSION (`git describe`).
Build Output: build
Fatal if: Build, test, or package fails.
Dependencies: git
]]

# See `execute_process` COMMAND_ERROR_IS_FATAL.
cmake_minimum_required(VERSION 3.19 FATAL_ERROR)

# Check dependencies.
find_package(Git REQUIRED)

# Variables.
execute_process(
    COMMAND "${GIT_EXECUTABLE}" describe --always
    OUTPUT_VARIABLE CI_BUILD_VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE COMMAND_ERROR_IS_FATAL ANY
)
include(ProcessorCount)
ProcessorCount(PROCESSOR_COUNT)
if(NOT PROCESSOR_COUNT)
    set(PROCESSOR_COUNT 2)
endif()
set(BUILD_DIR "build")
set(BUILD_TYPE "Release")
set(PACKAGE_DIR "${BUILD_DIR}/package")
set(PACKAGE_CONFIG "${BUILD_DIR}/CPackConfig.cmake")
set(PACKAGE_TEMP "${PACKAGE_DIR}/_CPack_Packages")
include(CMakePrintHelpers)
cmake_print_variables(
    PROCESSOR_COUNT
    BUILD_DIR
    BUILD_TYPE
    PACKAGE_DIR
    PACKAGE_CONFIG
    PACKAGE_TEMP
    CI_BUILD_VERSION
)

# Required configure.
execute_process(
    COMMAND
        "${CMAKE_COMMAND}" -B "${BUILD_DIR}"
        -DCMAKE_BUILD_TYPE:STRING="${BUILD_TYPE}"
        -DCI_BUILD_VERSION:STRING="${CI_BUILD_VERSION}" COMMAND_ERROR_IS_FATAL
        ANY
)

# Required build.
execute_process(
    COMMAND "${CMAKE_COMMAND}" --build "${BUILD_DIR}" --config "${BUILD_TYPE}"
            -j "${PROCESSOR_COUNT}" COMMAND_ERROR_IS_FATAL ANY
)

# Optional test (fatal if test exists and fails).
execute_process(
    COMMAND
        "${CMAKE_CTEST_COMMAND}" -C "${BUILD_TYPE}" -j "${PROCESSOR_COUNT}"
        --output-on-failure --test-dir "${BUILD_DIR}" COMMAND_ERROR_IS_FATAL
        ANY
)

#[[ Optional package (fatal if CPackConfig.cmake exists and packaging fails or
 temp files are not removable). ]]
execute_process(
    COMMAND
        "${CMAKE_CPACK_COMMAND}" -DCPACK_VERBATIM_VARIABLES:BOOL=TRUE
        -DCPACK_STRIP_FILES:BOOL=TRUE -B "${PACKAGE_DIR}" --config
        "${PACKAGE_CONFIG}" -C "${BUILD_TYPE}"
)
execute_process(
    COMMAND "${CMAKE_COMMAND}" -E rm -rf -- "${PACKAGE_TEMP}"
            COMMAND_ERROR_IS_FATAL ANY
)
