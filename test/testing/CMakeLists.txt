# Test testing.
include_guard(GLOBAL)
cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
project(testing)
# Inherits from building.
include(../building/CMakeLists.txt)
# Test
enable_testing()
add_test(NAME test COMMAND main)
if(NOT TEST test)
    message(FATAL_ERROR "Test step failed.")
endif()
