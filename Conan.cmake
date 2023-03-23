option(USE_CONAN "Use conan to manage dependencies" ON)
if(NOT USE_CONAN)
  return()
endif()

find_package(Conan REQUIRED)

if(NOT DEFINED CONAN_PROFILE_HOST)
  message(FATAL_ERROR "CONAN_PROFILE_HOST is required but it is not defined, please define it to be the path to the conan profile for the host machine")
endif()

if(NOT DEFINED CONAN_PROFILE_BUILD)
  message(STATUS "CONAN_PROFILE_BUILD is not defined, assuming native compilation, setting CONAN_PROFILE_BUILD to ${CONAN_PROFILE_HOST}")
  set(CONAN_PROFILE_BUILD "${CONAN_PROFILE_HOST}")
  set(native_build ON)
endif()

conan_detect_compiler(host_compiler host_compiler_version)

if(native_build)
  conan_install(
    "${CMAKE_CURRENT_SOURCE_DIR}"
    OUTPUT_FOLDER "${CMAKE_CURRENT_BINARY_DIR}"

    GENERATOR CMakeDeps

    PROFILE_HOST "${CONAN_PROFILE_HOST}"
    PROFILE_BUILD "${CONAN_PROFILE_BUILD}"

    SETTING_HOST build_type=${CMAKE_BUILD_TYPE}
    SETTING_HOST compiler=${host_compiler}
    SETTING_HOST compiler.version=${host_compiler_version}

    SETTING_BUILD build_type=Release
    SETTING_BUILD compiler=${host_compiler}
    SETTING_BUILD compiler.version=${host_compiler_version}

    BUILD missing
    VERBOSE error
    )
else()
  conan_install(
    "${CMAKE_CURRENT_SOURCE_DIR}"
    OUTPUT_FOLDER "${CMAKE_CURRENT_BINARY_DIR}"

    GENERATOR CMakeDeps

    PROFILE_HOST "${CONAN_PROFILE_HOST}"
    PROFILE_BUILD "${CONAN_PROFILE_BUILD}"

    SETTING_HOST build_type=${CMAKE_BUILD_TYPE}
    SETTING_HOST compiler=${host_compiler}
    SETTING_HOST compiler.version=${host_compiler_version}

    SETTING_BUILD build_type=Release

    BUILD missing
    VERBOSE error
    )
endif()


foreach(conanfile IN ITEMS "${CMAKE_CURRENT_SOURCE_DIR}/conanfile.txt" "${CMAKE_CURRENT_SOURCE_DIR}/conanfile.py")
  list(APPEND CMAKE_PREFIX_PATH "${CMAKE_CURRENT_BINARY_DIR}")
  set_property(
    DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    APPEND
    PROPERTY CMAKE_CONFIGURE_DEPENDS "${conanfile}"
  )
endforeach()
