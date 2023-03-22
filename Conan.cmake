option(USE_CONAN "Use conan to manage dependencies" ON)
if(NOT USE_CONAN)
  return()
endif()

find_package(Conan REQUIRED)

if(NOT DEFINED CONAN_PROFILE_BUILD)
  message(FATAL_ERROR "CONAN_PROFILE_BUILD is required but it is not defined, please define it to be the path to the conan profile for the build machine")
endif()
if(NOT DEFINED CONAN_PROFILE_HOST)
  message(FATAL_ERROR "CONAN_PROFILE_HOST is required but it is not defined, please define it to be the path to the conan profile for the host machine")
endif()

conan_install(
  "${CMAKE_CURRENT_SOURCE_DIR}"
  OUTPUT_FOLDER "${CMAKE_CURRENT_BINARY_DIR}"
  GENERATOR CMakeDeps
  PROFILE_BUILD "${CONAN_PROFILE_BUILD}"
  PROFILE_HOST "${CONAN_PROFILE_HOST}"
  SETTING_BUILD build_type=Release
  SETTING_HOST build_type=${CMAKE_BUILD_TYPE}
  BUILD missing
  VERBOSE error
)

foreach(conanfile IN ITEMS "${CMAKE_CURRENT_SOURCE_DIR}/conanfile.txt" "${CMAKE_CURRENT_SOURCE_DIR}/conanfile.py")
  list(APPEND CMAKE_PREFIX_PATH "${CMAKE_CURRENT_BINARY_DIR}")
  set_property(
    DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    APPEND
    PROPERTY CMAKE_CONFIGURE_DEPENDS "${conanfile}"
  )
endforeach()
