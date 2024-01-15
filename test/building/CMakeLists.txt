# Testing configuring and building.
include_guard(GLOBAL)
cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CXX_EXTENSIONS OFF)
if(NOT CI_BUILD_VERSION)
    set(CI_BUILD_VERSION "Development")
endif()
add_compile_definitions(CI_BUILD_VERSION=${CI_BUILD_VERSION})
message(STATUS "CI_BUILD_VERSION=${CI_BUILD_VERSION}")
project(building)
# Build
add_executable(main ../main.cpp)
