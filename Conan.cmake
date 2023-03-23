option(USE_CONAN "Use conan to manage dependencies" ON)
option(CONAN_AUTODETECT "Detect Conan settings automatically through CMake variables" OFF)
if(NOT USE_CONAN)
  return()
endif()

find_package(Conan REQUIRED)

if(NOT DEFINED CONAN_PROFILE_HOST)
  message(FATAL_ERROR "CONAN_PROFILE_HOST is required but it is not defined, please define it to be the path to the conan profile for the host machine")
endif()

list(APPEND conan_args PROFILE_HOST "${CONAN_PROFILE_HOST}")
if(DEFINED CONAN_PROFILE_BUILD)
  list(APPENND conan_args PROFILE_BUILD "${CONAN_PROFILE_BUILD}")
endif()

if(CONAN_AUTODETECT)
  conan_detect_compiler(compiler compiler_version)
  list(APPEND conan_args
    SETTING_HOST compiler=${compiler}
    SETTING_HOST compiler.version=${compiler_version})

  conan_detect_standard(standard)
  list(APPEND conan_args SETTING_HOST cppstd=${standard})

  conan_default_libcxx(${compiler} libcxx)
  list(APPEND conan_args SETTING_HOST libcxx=${libcxx})
endif()

conan_install(
  "${CMAKE_CURRENT_SOURCE_DIR}"
  OUTPUT_FOLDER "${CMAKE_CURRENT_BINARY_DIR}"
  BUILD missing
  VERBOSE error
  GENERATOR CMakeDeps
  ${conan_args}
)


foreach(conanfile IN ITEMS "${CMAKE_CURRENT_SOURCE_DIR}/conanfile.txt" "${CMAKE_CURRENT_SOURCE_DIR}/conanfile.py")
  list(APPEND CMAKE_PREFIX_PATH "${CMAKE_CURRENT_BINARY_DIR}")
  set_property(
    DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    APPEND
    PROPERTY CMAKE_CONFIGURE_DEPENDS "${conanfile}"
  )
endforeach()
