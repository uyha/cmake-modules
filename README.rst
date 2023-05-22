===================
River CMake Modules
===================
This is a collection of CMake scripts for various purposes, please read the subsections
of each script to see how to use them.

Using this repo
===============
To use this collection of CMake modules, please include this snippet in your CMake
script

.. code-block:: cmake

   include(FetchContent)
   FetchContent_Declare(river
                        GIT_REPOSITORY https://github.com/uyha/cmake-modules.git
                        GIT_TAG v0.1.0)
   FetchContent_MakeAvailable(river)
   list(APPEND CMAKE_MODULE_PATH "${river_BINARY_DIR}")

Ccache
======
This module finds and uses the `ccache`_ program to speed up recompilation.
To use this module, put ``include(Ccache)`` in your build script.

-----------------
Defined Variables
-----------------
- ``Ccache_EXECUTABLE``: The path to the `ccache`_ executable.

Conan
=====
This module invokes `conan`_ and installs the dependencies specified in either
*conanfile.txt* or *conanfile.py*. After this module is included, then the
`find_package` command can be used to make the dependencies appear as CMake targets.

--------------
Customizations
--------------
- ``USE_CONAN``: [ON, OFF] (Default: ON)

  This variable controls whether this module is active or not.

- ``CONAN_AUTODETECT``: [ON, OFF] (Default: OFF)

  This variable controls whether the autodetect feature should be used.

- ``CONAN_PROFILE_HOST``: Path (Required)

  The path to the profile for the hosting context.

- ``CONAN_PROFILE_BUILD``: Path (Optional)

  The path to the profile for the building context. If this variable is not
  provided, ``CONAN_PROFILE_HOST`` will be used.

FindConan
=========
This module finds the ``conan`` executable and provides CMake functions to interact with it.

-----------------
Defined Variables
-----------------
- ``Conan_EXECUTABLE``: The path to the ``conan`` executable.

- ``Conan_VERSION``: The version of the ``conan`` executable.

-----------------
Defined Functions
-----------------
- ``conan_install``: This function invokes the ``conan install`` command and passes the
  appropriate arguments to it. Please refer to
  `conan install <https://docs.conan.io/2/reference/commands/install.html>`_. The
  arguments for ``conan install`` are translated to CMake style arguments, i.e "--" is
  removed, ":" or "-" becomes "_", and the arguments are capitalized.

--------------
Customizations
--------------
- ``Conan_DIR``: Path (Optional)

  The path to the directory containing the ``conan`` executable.


Poetry
======
This module installs Python dependencies specified in *pyproject.toml* using `poetry`_.

-----------------
Defined Variables
-----------------
- ``Python_ROOT_DIR``: When ``find_package(Python)`` is used, the python interpreter
  will be found in the poetry virtual environment.

.. _ccache: https://ccache.dev/
.. _conan: https://conan.io/
.. _poetry: https://python-poetry.org/
