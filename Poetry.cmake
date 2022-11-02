find_package(Poetry REQUIRED)
if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/poetry.lock")
    file(COPY "${CMAKE_CURRENT_SOURCE_DIR}/pyproject.toml" DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
    poetry_install(DIR "${CMAKE_CURRENT_BINARY_DIR}" OPTIONS "--no-root" "--no-dev")
elseif("${CMAKE_CURRENT_SOURCE_DIR}/pyproject.toml" IS_NEWER_THAN "${CMAKE_CURRENT_BINARY_DIR}/poetry.lock")
    file(COPY "${CMAKE_CURRENT_SOURCE_DIR}/pyproject.toml" DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
    poetry_update(DIR "${CMAKE_CURRENT_BINARY_DIR}" OPTIONS "--no-dev")
endif()
poetry_path(Python_ROOT_DIR)
set(Python_ROOT_DIR "${Python_ROOT_DIR}" CACHE PATH "Path to the root directory of the target Python interpreter")
set_property(
  DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
  APPEND
  PROPERTY CMAKE_CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/pyproject.toml"
)

