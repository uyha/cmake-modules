find_program(Conan_EXECUTABLE conan HINTS ${Conan_DIR})

if(Conan_EXECUTABLE)
  if(NOT TARGET Conan::Conan AND NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    add_executable(Conan::Conan IMPORTED)
    set_target_properties(Conan::Conan PROPERTIES IMPORTED_LOCATION "${Conan_EXECUTABLE}")
  endif()
  if(WIN32)
    execute_process(
      COMMAND cmd /C ${Conan_EXECUTABLE} --version
      RESULT_VARIABLE result
      OUTPUT_VARIABLE version
      )
  else()
    execute_process(
      COMMAND ${Conan_EXECUTABLE} --version
      RESULT_VARIABLE result
      OUTPUT_VARIABLE version
      )
  endif()
  if(result EQUAL 0)
    if(${version} MATCHES ".*version(.*)")
      string(STRIP ${CMAKE_MATCH_1} Conan_VERSION)
    endif()
  endif()

  macro(_conan_add_flag option flag)
    if(arg_${option})
      list(APPEND optional_arguments ${flag})
    endif()
  endmacro()

  macro(_conan_add_value option flag)
    if(arg_${option})
      list(APPEND optional_arguments ${flag} "${arg_${option}}")
    endif()
  endmacro()

  macro(_conan_add_values option flag)
    if(arg_${option})
      foreach(var IN LISTS arg_${option})
        list(APPEND optional_arguments ${flag} "${var}")
      endforeach()
    endif()
  endmacro()

  function(conan_install)
    set(options LOGGER UPDATE NO_REMOTE LOCKFILE_PARTIAL LOCKFILE_PACKAGES LOCKFILE_CLEAN DEPLOY)
    set(single_values FORMAT VERBOSE NAME VERSION USER CHANNEL BUILD PROFILE_BUILD PROFILE_HOST LOCK_FILE LOCKFILE_OUT OUTPUT_FOLDER)
    set(multi_values REQUIRES TOOL_REQUIRES REMOTE OPTION_BUILD OPTION_HOST SETTING_BUILD SETTING_HOST CONF_BUILD CONF_HOST GENERATOR)
    cmake_parse_arguments(arg "${options}" "${single_values}" "${multi_values}" ${ARGN})

    if(arg_NO_REMOTE AND arg_REMOTE)
      message(FATAL_ERROR "NO_REMOTE and REMOTE cannot be specified at the same time")
    endif()

    _conan_add_flag(LOGGER --logger)
    _conan_add_flag(UPDATE --update)
    _conan_add_flag(NO_REMOTE --no-remote)
    _conan_add_flag(LOCKFILE_PARTIAL --lockfile-partial)
    _conan_add_flag(LOCKFILE_PACKAGES --lockfile-packages)
    _conan_add_flag(LOCKFILE_CLEAN --lockfile-clean)
    _conan_add_flag(DEPLOY --deploy)

    _conan_add_value(FORMAT --format)
    _conan_add_value(VERBOSE -v)
    _conan_add_value(NAME --name)
    _conan_add_value(VERSION --version)
    _conan_add_value(USER --user)
    _conan_add_value(CHANNEL --channel)
    _conan_add_value(BUILD --build)
    _conan_add_value(PROFILE_BUILD --profile:build)
    _conan_add_value(PROFILE_HOST --profile:host)
    _conan_add_value(LOCK_FILE --lockfile)
    _conan_add_value(LOCKFILE_OUT --lockfile-out)
    _conan_add_value(OUTPUT_FOLDER --output-folder)

    _conan_add_values(REQUIRES --requires)
    _conan_add_values(TOOL_REQUIRES --tool-requires)
    _conan_add_values(REMOTE --remote)
    _conan_add_values(OPTION_BUILD --options:build)
    _conan_add_values(OPTION_HOST --options:host)
    _conan_add_values(SETTING_BUILD --settings:build)
    _conan_add_values(SETTING_HOST --settings:host)
    _conan_add_values(CONF_BUILD --conf:build)
    _conan_add_values(CONF_HOST --conf:host)
    _conan_add_values(GENERATOR --generator)

    execute_process(
      COMMAND "${Conan_EXECUTABLE}" install ${optional_arguments} ${arg_UNPARSED_ARGUMENTS}
      COMMAND_ERROR_IS_FATAL LAST
      )
  endfunction()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Conan
  REQUIRED_VARS Conan_EXECUTABLE
  VERSION_VAR Conan_VERSION
)
