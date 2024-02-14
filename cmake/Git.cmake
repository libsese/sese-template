macro(get_git_hash _git_hash work_dir)
    find_package(Git)
    if (GIT_FOUND)
        execute_process(
                COMMAND ${GIT_EXECUTABLE} -C ${work_dir} --no-pager log -1 --pretty=format:%h
                OUTPUT_VARIABLE ${_git_hash}
                OUTPUT_STRIP_TRAILING_WHITESPACE
                WORKING_DIRECTORY .
                RESULT_VARIABLE GIT_RESULT
        )
        if (NOT GIT_RESULT EQUAL "0")
            message(FATAL_ERROR "failed to get the git repository hash value")
        endif ()
    endif ()
endmacro()

macro(get_git_branch _git_branch work_dir)
    find_package(Git)
    if (GIT_FOUND)
        execute_process(
                COMMAND ${GIT_EXECUTABLE} -C ${work_dir} --no-pager symbolic-ref --short -q HEAD
                OUTPUT_VARIABLE ${_git_branch}
                OUTPUT_STRIP_TRAILING_WHITESPACE
                WORKING_DIRECTORY .
                RESULT_VARIABLE GIT_RESULT
        )
        if (NOT GIT_RESULT EQUAL "0")
            # message(FATAL_ERROR "failed to get the git repository branch name")
            set(${_git_branch} "Unknown")
        endif ()
    endif ()
endmacro()

macro(git_update_submodule work_dir)
    find_package(Git)
    if (GIT_FOUND)
        execute_process(
                COMMAND ${GIT_EXECUTABLE} -C ${work_dir} submodule update --init --recursive
                WORKING_DIRECTORY .
                RESULT_VARIABLE GIT_RESULT
        )
        if (NOT GIT_RESULT EQUAL "0")
            message(FATAL_ERROR "failed to update the git submodule")
        endif ()
    endif ()
endmacro()