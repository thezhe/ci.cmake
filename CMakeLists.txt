include_guard(GLOBAL)
cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
project("thezhe/add_ci")
#[[
Add a `ci` utility target that builds, tests, and packages `all`

Pre:
- Called after all other non-meta targets added
- Tests and installs are in top-level list

Post:
- Packages install to "${CMAKE_CURRENT_BINARY_DIR}/artifacts"
]]
function(thezhe_add_ci)
    include(ProcessorCount)
    ProcessorCount(ci_processor_count)
    if(NOT ci_processor_count)
        set(ci_processor_count 2)
    endif()
    # CMake and CTest
    add_custom_target(
        ci
        "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}" --config
        "${CMAKE_BUILD_TYPE}" -j "${ci_processor_count}"
        COMMAND
            "${CMAKE_CTEST_COMMAND}" -C "${CMAKE_BUILD_TYPE}" -j
            "${ci_processor_count}" --output-on-failure --test-dir
            "${CMAKE_CURRENT_BINARY_DIR}"
        COMMENT "thezhe_add_ci: Building and testing with ${ci_processor_count} processes")
    # CPack
    if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/CPackConfig.cmake")
        return()
    endif()
    add_custom_command(
        TARGET ci
        POST_BUILD
        COMMAND
            "${CMAKE_CPACK_COMMAND}" -DCPACK_VERBATIM_VARIABLES:BOOL=TRUE
            -DCPACK_STRIP_FILES:BOOL=TRUE -DCPACK_THREADS=${ci_processor_count}
            -B "${CMAKE_CURRENT_BINARY_DIR}/artifacts" --config
            "${CMAKE_CURRENT_BINARY_DIR}/CPackConfig.cmake" -C
            "${CMAKE_BUILD_TYPE}"
        COMMAND "${CMAKE_COMMAND}" -E rm -rf --
                "${CMAKE_CURRENT_BINARY_DIR}/artifacts/_CPack_Packages"
        COMMENT
            "thezhe_add_ci: Installing artifacts to ${CMAKE_CURRENT_BINARY_DIR}/artifacts")
endfunction()
# Test
if(NOT PROJECT_IS_TOP_LEVEL)
    return()
endif()
# cmake-lint: disable=C0103
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CXX_EXTENSIONS OFF)
add_executable(test-main test/main.cpp)
enable_testing()
add_test(NAME test-main COMMAND test-main)
install(TARGETS test-main)
# cmake-lint: disable=C0103
set(CPACK_GENERATOR "ZIP")
set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}_${CMAKE_SYSTEM_NAME}")
include(CPack)
thezhe_add_ci()
