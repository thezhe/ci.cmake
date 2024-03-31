# Settings
include_guard(GLOBAL)
cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
# cmake-lint: disable=C0103
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CXX_EXTENSIONS OFF)
# Project
project(building)
string(APPEND ci_build_version_string "${CI_BUILD_VERSION}")
string(LENGTH "${ci_build_version_string}" ci_build_version_exists)
if(NOT "${ci_build_version_exists}")
    message(FATAL_ERROR "CI_BUILD_VERSION=\"${ci_build_version_string}\"")
endif()
add_compile_definitions(CI_BUILD_VERSION=${ci_build_version_string})
message(STATUS "CI_BUILD_VERSION=\"${ci_build_version_string}\"")
# Build
add_executable(main ../main.cpp)
