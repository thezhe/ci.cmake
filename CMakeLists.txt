#[[
CI entrypoint.

    cmake -B build && ctest -C Release --output-on-failure --test-dir build

Precondition: ./template.cmake and ./CTest.txt exist.
]]

# Project
cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
enable_testing()
project(template.cmake)
# Test
add_test(
    NAME CTest
    COMMAND "${CMAKE_COMMAND}" -P "template.cmake"
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
)
