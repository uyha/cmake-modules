option(USE_CONAN "Use conan to manage dependencies" ON)
if(NOT USE_CONAN)
  return()
endif()

find_package(Conan REQUIRED)
download_conan_cmake(conan_cmake DIR ${CMAKE_BINARY_DIR})
include(${conan_cmake})
if(${CMAKE_CURRENT_SOURCE_DIR}/conanfile.txt IS_NEWER_THAN ${CMAKE_CURRENT_BINARY_DIR}/conan.lock)
  file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/conanfile.txt DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
  if (DEFINED TARGET_ARCH)
    conan_cmake_autodetect(settings ARCH "${TARGET_ARCH}")
  else()
    conan_cmake_autodetect(settings)
  endif()
  conan_cmake_run(
    CONANFILE conanfile.txt
    BUILD missing
    SETTINGS ${settings}
  )
endif()
set_property(
  DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
  APPEND
  PROPERTY CMAKE_CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/conanfile.txt
)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_BINARY_DIR})
set(CONAN_CMAKE_SILENT_OUTPUT TRUE)
