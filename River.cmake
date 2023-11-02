macro(river_wrap_command)
  set(options ";")
  set(singles NAME MATCH_EXPRESSION REPLACE_EXPRESSION TOLOWER)
  set(multis COMMAND OPTIONS SINGLES MULTIPLES)
  cmake_parse_arguments(wrap "${options}" "${singles}" "${multis}" ${ARGN})

  if(NOT DEFINED wrap_NAME)
    message(FATAL_ERROR "NAME is required but not required")
  endif()
  if(NOT DEFINED wrap_COMMAND)
    message(FATAL_ERROR "COMMAND is required but not required")
  endif()

  if(NOT DEFINED wrap_MATCH_EXPRESSION)
    set(wrap_MATCH_EXPRESSION "_")
  endif()
  if(NOT DEFINED wrap_REPLACE_EXPRESSION)
    set(wrap_REPLACE_EXPRESSION "-")
  endif()
  if(NOT DEFINED wrap_TOLOWER)
    set(wrap_TOLOWER TRUE)
  endif()

  function(${wrap_NAME})
    # This is to avoid macro expanding the ARGN argument
    set(wrap_ARGN ARGN)
    cmake_parse_arguments(arg
      "${wrap_OPTIONS};"
      "${wrap_SINGLES};"
      "EXECUTE_PROCESS;${wrap_MULTIPLES}"
      ${${wrap_ARGN}}
    )

    foreach(arg IN ITEMS ${wrap_OPTIONS})
      if(${arg_${arg}})
        if(${wrap_TOLOWER})
          string(TOLOWER "${arg}" arg)
        endif()
        string(REGEX REPLACE
          "${wrap_MATCH_EXPRESSION}"
          "${wrap_REPLACE_EXPRESSION}"
          arg
          "${arg}"
        )
        list(APPEND args "--${arg}")
      endif()
    endforeach()

    foreach(arg IN ITEMS ${wrap_SINGLES})
      if(DEFINED arg_${arg})
        set(value "${arg_${arg}}")
        if(${wrap_TOLOWER})
          string(TOLOWER "${arg}" arg)
        endif()
        string(REGEX REPLACE
          "${wrap_MATCH_EXPRESSION}"
          "${wrap_REPLACE_EXPRESSION}"
          arg
          "${arg}"
        )
        list(APPEND args "--${arg}" "${value}")
      endif()
    endforeach()

    foreach(arg IN ITEMS ${wrap_MULTIPLES})
      if(DEFINED arg_${arg})
        set(value "${arg_${arg}}")
        if(${wrap_TOLOWER})
          string(TOLOWER "${arg}" arg)
        endif()
        string(REGEX REPLACE
          "${wrap_MATCH_EXPRESSION}"
          "${wrap_REPLACE_EXPRESSION}"
          arg
          "${arg}"
        )
        list(APPEND args "--${arg}" "${value}")
      endif()
    endforeach()

    if(WIN32)
      execute_process(
        COMMAND cmd /C ${wrap_COMMAND} ${args}
        ${arg_EXECUTE_PROCESS_ARGS}
      )
    else()
      execute_process(
        COMMAND ${wrap_COMMAND} ${args}
        ${arg_EXECUTE_PROCESS}
      )
    endif()
  endfunction()
endmacro()
