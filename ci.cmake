#[[
Build all CMake targets from ./CMakeLists.txt in Release mode.
Then test and package if applicable.
Hereinafter, "test" or "package" implies the step exists.

    cmake -P <path-to-ci.cmake>

Package Output: build/package
Cache Variables: CI_BUILD_VERSION
(see https://github.com/thezhe/templatepp/blob/master/CMakeLists.txt)
Build Output: build
Fatal if: build, test, or package fails
Dependencies: git
]]

# See `COMMAND_ERROR_IS_FATAL` in `execute_process`
cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
# Dependencies
find_package(Git REQUIRED)
# Variables
execute_process(
    COMMAND "${GIT_EXECUTABLE}" describe --tags --always
    OUTPUT_VARIABLE ci_build_version
    OUTPUT_STRIP_TRAILING_WHITESPACE COMMAND_ERROR_IS_FATAL ANY)
include(ProcessorCount)
ProcessorCount(ci_processor_count)
if(NOT ci_processor_count)
    set(ci_processor_count 4)
endif()
set(ci_build_dir "build")
set(ci_build_type "Release")
set(ci_package_config "${ci_build_dir}/CPackConfig.cmake")
set(ci_package_dir "${ci_build_dir}/package")
set(ci_package_temp "${ci_package_dir}/_CPack_Packages")
include(CMakePrintHelpers)
cmake_print_variables(
    ci_build_dir ci_build_type ci_build_version ci_package_dir
    ci_package_config ci_package_temp ci_processor_count)
# Configure
execute_process(
    COMMAND
        "${CMAKE_COMMAND}" -B "${ci_build_dir}"
        -DCMAKE_BUILD_TYPE:STRING="${ci_build_type}"
        -DCI_BUILD_VERSION:STRING="${ci_build_version}" COMMAND_ERROR_IS_FATAL
        ANY)
# Build
execute_process(
    COMMAND
        "${CMAKE_COMMAND}" --build "${ci_build_dir}" --config
        "${ci_build_type}" -j "${ci_processor_count}" COMMAND_ERROR_IS_FATAL
        ANY)
# Test
execute_process(
    COMMAND
        "${CMAKE_CTEST_COMMAND}" -C "${ci_build_type}" -j
        "${ci_processor_count}" --output-on-failure --test-dir
        "${ci_build_dir}" COMMAND_ERROR_IS_FATAL ANY)
# Package and remove temp files if possible
if(NOT EXISTS "${ci_package_config}")
    return()
endif()
execute_process(
    COMMAND
        "${CMAKE_CPACK_COMMAND}" -DCPACK_VERBATIM_VARIABLES:BOOL=TRUE
        -DCPACK_STRIP_FILES:BOOL=TRUE -B "${ci_package_dir}" --config
        "${ci_package_config}" -C "${ci_build_type}" COMMAND_ERROR_IS_FATAL ANY)
execute_process(COMMAND "${CMAKE_COMMAND}" -E rm -rf -- "${ci_package_temp}"
                        COMMAND_ERROR_IS_FATAL ANY)
