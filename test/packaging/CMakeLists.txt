# Test packaging.
include_guard(GLOBAL)
cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
project(packaging)
# Inherits from testing.
include(../testing/CMakeLists.txt)
# Package
install(TARGETS main)
set(CPACK_GENERATOR "ZIP")
set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}_${CMAKE_SYSTEM_NAME}")
include(CPack)
