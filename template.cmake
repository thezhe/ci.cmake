#[[
A self-contained CMake script. Reads `./CTest.txt`.

    cmake -P <path-to-template.cmake>

Fatal if: reading fails.
]]

# See `execute_process` COMMAND_ERROR_IS_FATAL.
cmake_minimum_required(VERSION 3.19 FATAL_ERROR)

# CLI
set(TEMPLATE_ARGC 3)
if(NOT ${CMAKE_ARGC} EQUAL ${TEMPLATE_ARGC})
    message(FATAL_ERROR "Usage: cmake -P  <path-to-template.cmake>")
endif()

# Read
file(READ "CTest.txt" TEMPLATE_CTEST_TXT)
execute_process(
    COMMAND "${CMAKE_COMMAND}" -E echo "${TEMPLATE_CTEST_TXT}"
            COMMAND_ERROR_IS_FATAL ANY
)
