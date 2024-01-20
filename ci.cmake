#[[
Build all CMake targets from ./CMakeLists.txt in Release mode.
Then test and package if applicable.
Hereinafter, "test" or "package" implies the step exists.

    cmake -P <path-to-ci.cmake>

Package Output: build/package
Cache Variables: CI_BUILD_VERSION (`git describe`)
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
    COMMAND "${GIT_EXECUTABLE}" describe --always
    OUTPUT_VARIABLE ci_build_version
    OUTPUT_STRIP_TRAILING_WHITESPACE COMMAND_ERROR_IS_FATAL ANY)
include(ProcessorCount)
ProcessorCount(processor_count)
if(NOT processor_count)
    set(processor_count 4)
endif()
set(build_dir "build")
set(build_type "Release")
set(package_dir "${build_dir}/package")
set(package_config "${build_dir}/CPackConfig.cmake")
set(package_temp "${package_dir}/_CPack_Packages")
include(CMakePrintHelpers)
cmake_print_variables(processor_count build_dir build_type package_dir
                      package_config package_temp ci_build_version)
# Configure
execute_process(
    COMMAND
        "${CMAKE_COMMAND}" -B "${build_dir}"
        -DCMAKE_BUILD_TYPE:STRING="${build_type}"
        -DCI_BUILD_VERSION:STRING="${ci_build_version}" COMMAND_ERROR_IS_FATAL
        ANY)
# Build
execute_process(
    COMMAND "${CMAKE_COMMAND}" --build "${build_dir}" --config "${build_type}"
            -j "${processor_count}" COMMAND_ERROR_IS_FATAL ANY)
# Test
execute_process(
    COMMAND
        "${CMAKE_CTEST_COMMAND}" -C "${build_type}" -j "${processor_count}"
        --output-on-failure --test-dir "${build_dir}" COMMAND_ERROR_IS_FATAL
        ANY)
# Package (fatal if temp files are not removeable)
execute_process(
    COMMAND
        "${CMAKE_CPACK_COMMAND}" -DCPACK_VERBATIM_VARIABLES:BOOL=TRUE
        -DCPACK_STRIP_FILES:BOOL=TRUE -B "${package_dir}" --config
        "${package_config}" -C "${build_type}")
execute_process(COMMAND "${CMAKE_COMMAND}" -E rm -rf -- "${package_temp}"
                        COMMAND_ERROR_IS_FATAL ANY)
