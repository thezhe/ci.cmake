# Test building
include_guard(GLOBAL)
cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
# cmake-lint: disable=C0103
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CXX_EXTENSIONS OFF)
project(building)
# CI_BUILD_VERSION
if(NOT CI_BUILD_VERSION)
    message(FATAL_ERROR "CI_BUILD_VERSION=${CI_BUILD_VERSION}")
endif()
add_compile_definitions(CI_BUILD_VERSION=${CI_BUILD_VERSION})
message(STATUS "CI_BUILD_VERSION=${CI_BUILD_VERSION}")
# Build
add_executable(main ../main.cpp)
