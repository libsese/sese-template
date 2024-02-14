cmake_minimum_required(VERSION 3.13)
# include sese tools
include(cmake/SeseTools.cmake)
# auto find vcpkg chain file
sese_auto_find_vcpkg()

# project
project(sese-template VERSION 0.0.1)

# find_package
find_package(sese CONFIG REQUIRED)

# target: template
# sese_add_library(template)
sese_add_executable(template)
sese_get_files(SRC "src")
target_sources(template PRIVATE ${SRC})
# need to copy the dll manually
# sese_enable_asan(template)

# if template is a library
# sese_auto_export_symbols(template)

# target: test0
sese_add_executable(unittest)
sese_get_files(UNIT_SRC "test")
target_sources(unittest PRIVATE ${UNIT_SRC})
# if template is a library
# target_link_libraries(unittest PRIVATE template)

# todo install