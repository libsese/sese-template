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
    set(VCPKG_FOUND OFF)
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
endmacro()