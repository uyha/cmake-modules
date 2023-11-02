find_program(Pdm_EXECUTABLE pdm HINTS "${Pdm_DIR}")

if(Pdm_EXECUTABLE)
  if(NOT TARGET Pdm::Pdm)
    add_executable(Pdm::Pdm IMPORTED)
    set_target_properties(Pdm::Pdm
      PROPERTIES
        IMPORTED_LOCATION "${Pdm_EXECUTABLE}"
    )
  endif()
  if(WIN32)
    execute_process(
      COMMAND cmd /C "${Pdm_EXECUTABLE}" --version
      RESULT_VARIABLE result
      OUTPUT_VARIABLE version
    )
  else()
    execute_process(
      COMMAND "${Pdm_EXECUTABLE}" --version
      RESULT_VARIABLE result
      OUTPUT_VARIABLE version
    )
  endif()

  if("${result}" EQUAL 0)
    if("${version}" MATCHES "PDM, version (.*)")
      string(STRIP "${CMAKE_MATCH_1}" Pdm_VERSION)
    endif()
  endif()

  include(River)

  river_wrap_command(
    NAME pdm_install
    COMMAND "${Pdm_EXECUTABLE}" install
    OPTIONS
      VERBOSE QUIET GLOBAL DRY_RUN NO_LOCK CHECK PLUGINS NO_DEFAULT DEV PRODUCTION
      NO_EDITABLE NO_SELF FAIL_FAST NO_ISOLATION
    SINGLES
      PROJECT LOCK_FILE SKIP GROUP
  )
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  Pdm
  REQUIRED_VARS Pdm_EXECUTABLE
  VERSION_VAR Pdm_VERSION
)
