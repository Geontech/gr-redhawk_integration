INCLUDE(FindPkgConfig)
PKG_CHECK_MODULES(PC_REDHAWK_INTEGRATION redhawk_integration)

FIND_PATH(
    REDHAWK_INTEGRATION_INCLUDE_DIRS
    NAMES redhawk_integration/api.h
    HINTS $ENV{REDHAWK_INTEGRATION_DIR}/include
        ${PC_REDHAWK_INTEGRATION_INCLUDEDIR}
    PATHS ${CMAKE_INSTALL_PREFIX}/include
          /usr/local/include
          /usr/include
)

FIND_LIBRARY(
    REDHAWK_INTEGRATION_LIBRARIES
    NAMES gnuradio-redhawk_integration
    HINTS $ENV{REDHAWK_INTEGRATION_DIR}/lib
        ${PC_REDHAWK_INTEGRATION_LIBDIR}
    PATHS ${CMAKE_INSTALL_PREFIX}/lib
          ${CMAKE_INSTALL_PREFIX}/lib64
          /usr/local/lib
          /usr/local/lib64
          /usr/lib
          /usr/lib64
)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(REDHAWK_INTEGRATION DEFAULT_MSG REDHAWK_INTEGRATION_LIBRARIES REDHAWK_INTEGRATION_INCLUDE_DIRS)
MARK_AS_ADVANCED(REDHAWK_INTEGRATION_LIBRARIES REDHAWK_INTEGRATION_INCLUDE_DIRS)

