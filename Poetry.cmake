find_package(Poetry REQUIRED)

if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/pyproject.toml")
  message(STATUS "No pyproject.toml found, skipping setting Poetry up")
  return()
endif()

poetry_path(Python_ROOT_DIR DIR "${CMAKE_CURRENT_SOURCE_DIR}")

if(Python_ROOT_DIR STREQUAL "" OR NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/poetry.lock")
  poetry_install(DIR "${CMAKE_CURRENT_SOURCE_DIR}" OPTIONS "--no-root")
  poetry_path(Python_ROOT_DIR DIR "${CMAKE_CURRENT_SOURCE_DIR}")
# IS_NEWER_THAN returns true when both files have the same timestamp, the inverted condition is needed here
elseif(NOT "${CMAKE_CURRENT_SOURCE_DIR}/poetry.lock" IS_NEWER_THAN "${CMAKE_CURRENT_SOURCE_DIR}/pyproject.toml")
  poetry_update(DIR "${CMAKE_CURRENT_SOURCE_DIR}")
endif()

set(Python_ROOT_DIR "${Python_ROOT_DIR}" CACHE PATH "Path to the root directory of the target Python interpreter")

set_property(
  DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
  APPEND
  PROPERTY CMAKE_CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/pyproject.toml"
  )

