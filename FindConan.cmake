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

  macro(_conan_install_add_flag option flag)
    if(arg_${option})
      list(APPEND optional_arguments ${flag})
    endif()
  endmacro()

  macro(_conan_install_add_value option flag)
    if(arg_${option})
      list(APPEND optional_arguments ${flag} "${arg_${option}}")
    endif()
  endmacro()

  macro(_conan_install_add_values option flag)
    if(arg_${option})
      foreach(var IN LISTS arg_${option})
        list(APPEND optional_arguments ${flag} "${var}")
      endforeach()
    endif()
  endmacro()

  function(conan_install)
    set(options UPDATE NO_REMOTE LOCKFILE_PARTIAL LOCKFILE_CLEAN BUILD_REQUIRE)
    set(single_values CORE_CONF FORMAT VERBOSE NAME VERSION USER CHANNEL BUILD
                      PROFILE_BUILD PROFILE_HOST LOCK_FILE LOCKFILE_OUT OUTPUT_FOLDER
                      DEPLOYER_FOLDER
    )
    set(multi_values REQUIRES TOOL_REQUIRES REMOTE
                     OPTION_BUILD OPTION_HOST SETTING_BUILD SETTING_HOST
                     CONF_BUILD CONF_HOST
                     GENERATOR DEPLOYER DEPLOYER_PACKAGE
    )
    cmake_parse_arguments(arg "${options}" "${single_values}" "${multi_values}" ${ARGN})

    if(arg_NO_REMOTE AND arg_REMOTE)
      message(FATAL_ERROR "NO_REMOTE and REMOTE cannot be specified at the same time")
    endif()

    _conan_install_add_flag(UPDATE --update)
    _conan_install_add_flag(NO_REMOTE --no-remote)
    _conan_install_add_flag(LOCKFILE_PARTIAL --lockfile-partial)
    _conan_install_add_flag(LOCKFILE_CLEAN --lockfile-clean)
    _conan_install_add_flag(BUILD_REQUIRE --build-require)

    _conan_install_add_value(CORE_CONF --core-conf)
    _conan_install_add_value(FORMAT --format)
    _conan_install_add_value(VERBOSE -v)
    _conan_install_add_value(NAME --name)
    _conan_install_add_value(VERSION --version)
    _conan_install_add_value(USER --user)
    _conan_install_add_value(CHANNEL --channel)
    _conan_install_add_value(BUILD --build)
    _conan_install_add_value(PROFILE_BUILD --profile:build)
    _conan_install_add_value(PROFILE_HOST --profile:host)
    _conan_install_add_value(LOCK_FILE --lockfile)
    _conan_install_add_value(LOCKFILE_OUT --lockfile-out)
    _conan_install_add_value(OUTPUT_FOLDER --output-folder)
    _conan_install_add_value(DEPLOYER_FOLDER --deployer-folder)

    _conan_install_add_values(REQUIRES --requires)
    _conan_install_add_values(TOOL_REQUIRES --tool-requires)
    _conan_install_add_values(REMOTE --remote)
    _conan_install_add_values(OPTION_BUILD --options:build)
    _conan_install_add_values(OPTION_HOST --options:host)
    _conan_install_add_values(SETTING_BUILD --settings:build)
    _conan_install_add_values(SETTING_HOST --settings:host)
    _conan_install_add_values(CONF_BUILD --conf:build)
    _conan_install_add_values(CONF_HOST --conf:host)
    _conan_install_add_values(GENERATOR --generator)
    _conan_install_add_values(DEPLOYER --deployer)
    _conan_install_add_values(DEPLOYER_PACKAGE --deployer-package)

    execute_process(
      COMMAND "${Conan_EXECUTABLE}" install ${optional_arguments} ${arg_UNPARSED_ARGUMENTS}
      COMMAND_ERROR_IS_FATAL LAST
      )
  endfunction()

  # Adapted from https://github.com/conan-io/cmake-conan/blob/develop2/conan_support.cmake
  function(conan_detect_compiler compiler version)
    if(NOT DEFINED CMAKE_CXX_COMPILER_ID AND NOT DEFINED CMAKE_C_COMPILER_ID)
      message(FATAL_ERROR "CMAKE_CXX_COMPILER_ID and CMAKE_C_COMPILER_ID are not defined, could not detect the compiler (at least 1 of them needs to be defined)")
    endif()

    if(DEFINED CMAKE_CXX_COMPILER_ID)
      set(compiler_id "${CMAKE_CXX_COMPILER_ID}")
      set(compiler_version "${CMAKE_CXX_COMPILER_VERSION}")
    else()
      set(compiler_id "${CMAKE_C_COMPILER_ID}")
      set(compiler_version "${CMAKE_C_COMPILER_VERSION}")
    endif()

    if(compiler_id MATCHES MSVC)
      set(compiler_result msvc)
      string(SUBSTRING ${MSVC_VERSION} 0 3 version_result)
    elseif(compiler_id MATCHES GNU)
      set(compiler_result gcc)
      string(REGEX REPLACE "\\.[0-9]+$" "" version_result "${compiler_version}")
    elseif(compiler_id MATCHES Clang)
      set(compiler_result clang)
      string(REGEX REPLACE "\\.[0-9]+$" "" version_result "${compiler_version}")
    elseif(compiler_id MATCHES AppleClang)
      set(compiler_result apple-clang)
      string(REGEX REPLACE "\\.[0-9]+$" "" version_result "${compiler_version}")
    else()
      message(FATAL_ERROR "Unknown compiler, cannot detect")
    endif()

    set(${compiler} ${compiler_result} PARENT_SCOPE)
    set(${version} ${version_result} PARENT_SCOPE)
  endfunction()

  function(conan_default_standard compiler version standard)
    if(compiler MATCHES gcc)
      if(version VERSION_GREATER_EQUAL 10)
        set(result 20)
      elseif(version VERSION_GREATER_EQUAL 9)
        set(result 17)
      else()
        set(result 14)
      endif()
    elseif(compiler MATCHES clang)
      if(version VERSION_GREATER_EQUAL 10)
        set(result 20)
      elseif(version VERSION_GREATER_EQUAL 5)
        set(result 17)
      else()
        set(result 14)
      endif()
    else()
      message(FATAL_ERROR "Unknown compiler, cannot detect standard")
    endif()

    set(${standard} ${result} PARENT_SCOPE)
  endfunction()

  function(conan_default_libcxx compiler libcxx)
    if(compiler MATCHES "gcc")
      set(${libcxx} libstdc++11 PARENT_SCOPE)
    elseif(compiler MATCHES "clang")
      if(CMAKE_CXX_FLAGS MATCHES [[-stdlib=libc\+\+]])
        set(${libcxx} libc++ PARENT_SCOPE)
      else()
        set(${libcxx} libstdc++11 PARENT_SCOPE)
      endif()
    endif()
  endfunction()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Conan
  REQUIRED_VARS Conan_EXECUTABLE
  VERSION_VAR Conan_VERSION
)
