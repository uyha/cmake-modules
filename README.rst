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

--------------
Customizations
--------------
- ``CCACHE_SLOPPINESS``: This variable controls the sloppiness of `ccache`_ (default:
  ``pch_defines,time_macros``)

.. _ccache: https://ccache.dev/
