option(USE_CONAN "Use conan to manage dependencies" ON)
if(NOT USE_CONAN)
  return()
endif()

find_package(Conan REQUIRED)
conan_install(
  "${CMAKE_CURRENT_SOURCE_DIR}"
  OUTPUT_FOLDER "${CMAKE_CURRENT_BINARY_DIR}"
  GENERATOR CMakeDeps
  SETTING_BUILD build_type=Release
  SETTING_HOST build_type=${CMAKE_BUILD_TYPE}
  BUILD missing
  VERBOSE quiet
)
list(APPEND CMAKE_PREFIX_PATH "${CMAKE_CURRENT_BINARY_DIR}")
set_property(
  DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
  APPEND
  PROPERTY CMAKE_CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/conanfile.txt
)
