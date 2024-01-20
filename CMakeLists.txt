#[[
CI entrypoint See .github/workflows/main.yml for usage.
]]

# Project
cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
enable_testing()
project(ci.cmake)
# Test
function(add_ci_test testDir)
    add_test(
        NAME "${testDir}"
        COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_SOURCE_DIR}/ci.cmake"
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}/test/${testDir}"
    )
endfunction()
add_ci_test(building)
add_ci_test(testing)
add_ci_test(packaging)
