find_package(Pdm REQUIRED)

set(pyproject "${CMAKE_CURRENT_SOURCE_DIR}/pyproject.toml")

if(NOT EXISTS "${pyproject}")
  message(STATUS "No pyproject.toml found, skipping PDM")
  return()
endif()

if("${pyproject}" IS_NEWER_THAN "${CMAKE_CURRENT_SOURCE_DIR}/pdm.lock")
  pdm_install(QUIET NO_SELF
    EXECUTE_PROCESS
      WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
  )
  file(TOUCH_NOCREATE "${CMAKE_CURRENT_SOURCE_DIR}/pdm.lock")
endif()

file(READ "${CMAKE_CURRENT_SOURCE_DIR}/.pdm-python" Python_ROOT_DIR)
cmake_path(GET Python_ROOT_DIR PARENT_PATH Python_ROOT_DIR)
cmake_path(GET Python_ROOT_DIR PARENT_PATH Python_ROOT_DIR)
set(Python_ROOT_DIR
  "${Python_ROOT_DIR}"
  CACHE PATH
  "Path to the root directory of the target Python interpreter"
)

set_property(
  DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
  APPEND
  PROPERTY CMAKE_CONFIGURE_DEPENDS "${pyproject}"
)
