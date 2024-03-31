# Settings
include_guard(GLOBAL)
cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
enable_testing()
# Project
project(testing)
# Inherit from building
include(../building/CMakeLists.txt)
# Test
add_test(NAME testing-test COMMAND main)
if(NOT TEST testing-test)
    message(FATAL_ERROR "Test step failed.")
endif()
