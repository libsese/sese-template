macro(sese_auto_enable_feature opt_name feature_name)
    if (${opt_name})
        if (NOT DEFINED VCPKG_MANIFEST_FEATURES)
            message(STATUS "Auto append features: ${feature_name}")
            set(VCPKG_MANIFEST_FEATURES ${feature_name})
        else ()
            list(FIND VCPKG_MANIFEST_FEATURES ${opt_name} index)
            if (index EQUAL -1)
                message(STATUS "Auto append features: ${feature_name}")
                list(APPEND VCPKG_MANIFEST_FEATURES ${feature_name})
            endif ()
        endif ()
    endif ()
endmacro()


macro(SESE_AUTO_EXPORT_SYMBOLS TARGET_NAME)
    get_target_property(${TARGET_NAME}_TYPE ${TARGET_NAME} TYPE)
    if (NOT ${TARGET_NAME}_TYPE STREQUAL "EXECUTABLE")
        set_target_properties(${TARGET_NAME} PROPERTIES
                WINDOWS_EXPORT_ALL_SYMBOLS ON
        )
    endif ()
endmacro()

macro(SESE_GET_FILES FILES PATH)
    file(
            GLOB_RECURSE
            ${FILES}
            "${PATH}/*.cpp"
            "${PATH}/*.cxx"
            "${PATH}/*.cc"
            "${PATH}/*.c"
            "${PATH}/*.h"
            "${PATH}/*.hpp"
    )
endmacro()

macro(SESE_ENABLE_COVERAGE TARGET_NAME)
    target_compile_options(${TARGET_NAME} PRIVATE "--coverage -fprofile-update=atomic")
endmacro()

macro(SESE_ENABLE_ASAN TARGET_NAME)
    target_compile_options(${TARGET_NAME} PRIVATE "-fsanitize=address")
endmacro()

macro(SESE_TARGET_INCLUDE TARGET_NAME INCLUDE_DIR)
    target_include_directories(
            ${TARGET_NAME}
            PUBLIC
            $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/${INCLUDE_DIR}>
            $<INSTALL_INTERFACE:include>
    )
endmacro()

macro(SESE_ADD_EXECUTABLE TARGET_NAME)
    add_executable(${TARGET_NAME})
    target_link_libraries(${TARGET_NAME} PRIVATE Sese::Core)
    set_target_properties(${TARGET_NAME} PROPERTIES
            CXX_STANDARD 17
    )
    if (${MSVC})
        target_compile_options(${TARGET_NAME} PRIVATE /utf-8)
    endif ()
    if (${UNIX})
        target_compile_options(${TARGET_NAME} PRIVATE -fPIC -gdwarf-4)
    endif ()
endmacro()

macro(SESE_ADD_LIBRARY TARGET_NAME)
    add_library(${TARGET_NAME})
    target_link_libraries(${TARGET_NAME} PRIVATE Sese::Core)
    set_target_properties(${TARGET_NAME} PROPERTIES
            CXX_STANDARD 17
    )
    if (${MSVC})
        target_compile_options(${TARGET_NAME} PRIVATE /utf-8)
    endif ()
    if (${UNIX})
        target_compile_options(${TARGET_NAME} PRIVATE -fPIC -gdwarf-4)
    endif ()
endmacro()

macro(SESE_AUTO_FIND_VCPKG)
    if (NOT VCPKG_FOUND)
        if (DEFINED CMAKE_TOOLCHAIN_FILE)
            get_filename_component(FILENAME ${CMAKE_TOOLCHAIN_FILE} NAME)
            if (${FILENAME} STREQUAL "vcpkg.cmake")
                set(VCPKG_FOUND ON)
            endif ()
        endif ()

        if (NOT VCPKG_FOUND)
            if (NOT $ENV{VCPKG_ROOT} STREQUAL "")
                set(VCPKG_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake")
                message(STATUS "VCPKG_TOOLCHAIN_FILE :${VCPKG_TOOLCHAIN_FILE}")
                include(${VCPKG_TOOLCHAIN_FILE})
            else ()
                find_path(VCPKG_TOOLCHAIN_DIR vcpkg.cmake
                        C:/src/vcpkg/scripts/buildsystems
                        C:/vcpkg/scripts/buildsystems
                        D:/vcpkg/scripts/buildsystems
                        E:/vcpkg/scripts/buildsystems
                        F:/vcpkg/scripts/buildsystems
                        C:/Users/$ENV{USER}/vcpkg/scripts/buildsystems
                        C:/Users/$ENV{USER}/.vcpkg/scripts/buildsystems
                        /usr/local/vcpkg/scripts/buildsystems
                        /src/vcpkg/scripts/buildsystems
                        /home/$ENV{USER}/vcpkg/scripts/buildsystems
                        /home/$ENV{USER}/.vcpkg/scripts/buildsystems
                        /Users/$ENV{USER}/vcpkg/scripts/buildsystems
                        /Users/$ENV{USER}/.vcpkg/scripts/buildsystems
                )

                if (${VCPKG_TOOLCHAIN_DIR} STREQUAL "")
                    message(FATAL_ERROR "Could not found the vcpkg.cmake")
                else ()
                    message(STATUS "VCPKG_TOOLCHAIN_FILE :${VCPKG_TOOLCHAIN_DIR}/vcpkg.cmake")
                    include("${VCPKG_TOOLCHAIN_DIR}/vcpkg.cmake")
                endif ()
            endif ()
        endif ()
    endif ()
endmacro()

macro(SESE_PACKAGE_CONFIG CONFIG_FILE TARGET_FILE_NAME)
    set(TARGET_FILE_NAME ${TARGET_FILE_NAME})
    include(GNUInstallDirs)
    include(CMakePackageConfigHelpers)
    configure_package_config_file(
            ${PROJECT_SOURCE_DIR}/cmake/config.cmake.in
            ${PROJECT_BINARY_DIR}/${CONFIG_FILE}.cmake
            INSTALL_DESTINATION lib/cmake/${PROJECT_NAME}
    )
    install(
            FILES ${PROJECT_BINARY_DIR}/${CONFIG_FILE}.cmake
            DESTINATION lib/cmake/${PROJECT_NAME}
    )
    install(
            FILES ${PROJECT_BINARY_DIR}/${CONFIG_FILE}.cmake
            DESTINATION debug/lib/cmake/${PROJECT_NAME}
    )
endmacro()

macro(SESE_EXPORT_TARGETS NAMESPACE)
    message(STATUS ${ARGN})
    install(
            TARGETS ${ARGN}
            EXPORT ${TARGET_FILE_NAME}
            RUNTIME DESTINATION bin
            LIBRARY DESTINATION lib
            ARCHIVE DESTINATION lib
            PUBLIC_HEADER DESTINATION include
    )

    install(
            EXPORT ${TARGET_FILE_NAME}
            DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
            NAMESPACE ${NAMESPACE}
    )
endmacro()