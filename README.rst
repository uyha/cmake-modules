===================
River CMake Modules
===================
This is a collection of CMake scripts for various purposes, please read the subsections
of each script to see how to use them.

Using this module
=================
To use this collection of CMake modules, please include this snippet in your CMake
script

.. code-block:: cmake

   include(FetchContent)
   FetchContent_Declare(river
                        GIT_REPOSITORY https://github.com/uyha/cmake-modules.git
                        GIT_TAG v0.1.0)
   FetchContent_MakeAvailable(river)
