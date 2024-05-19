cmake_minimum_required(VERSION 3.13)
# include sese tools
include(cmake/SeseTools.cmake)
# auto detect triplet
# sese_auto_detect_triplet()
# auto find vcpkg chain file
sese_auto_find_vcpkg()

# project
project(sese-template VERSION 0.0.1)

if (MSVC AND VCPKG_TARGET_TRIPLET STREQUAL "x64-windows-static")
    set(CMAKE_CXX_FLAGS_DEBUG /MTd)
    set(CMAKE_CXX_FLAGS_MINSIZEREL /MT)
    set(CMAKE_CXX_FLAGS_RELEASE /MT)
    set(CMAKE_CXX_FLAGS_RELWITHDEBUGINFO /MT)
endif ()

# find_package
find_package(sese CONFIG REQUIRED)

# target: template
# sese_add_library(template)
sese_add_executable(template)
sese_target_include(template "src")
sese_get_files(SRC "src")
target_sources(template PRIVATE ${SRC})
# need to copy the asan dll manually
# sese_enable_asan(template)

# if template is a library
# sese_auto_export_symbols(template)

# target: unittest
sese_add_executable(unittest)
sese_get_files(UNIT_SRC "test")
target_sources(unittest PRIVATE ${UNIT_SRC})
# if template is a library
# target_link_libraries(unittest PRIVATE template)

# target: install
# fixed combination
sese_package_config(template-config TemplateTargets)
sese_export_targets(template:: template unittest)