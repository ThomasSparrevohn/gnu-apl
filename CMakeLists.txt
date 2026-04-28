cmake_minimum_required(VERSION 3.16)

project(GnuAPL
    VERSION 2.0
    DESCRIPTION "GNU APL interpreter"
    HOMEPAGE_URL "https://www.gnu.org/software/apl/"
    LANGUAGES CXX C
)

# ---------------------------------------------------------------------------
# C++ standard
# ---------------------------------------------------------------------------
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Default build type
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING
        "Build type (Debug|Release|RelWithDebInfo|MinSizeRel)" FORCE)
endif()

# ---------------------------------------------------------------------------
# Installation directories (GNUInstallDirs)
# ---------------------------------------------------------------------------
include(GNUInstallDirs)

# locale dir not always provided by older CMake; compute from datarootdir
if(NOT DEFINED CMAKE_INSTALL_LOCALEDIR)
    set(CMAKE_INSTALL_LOCALEDIR "${CMAKE_INSTALL_DATAROOTDIR}/locale")
endif()
if(NOT IS_ABSOLUTE "${CMAKE_INSTALL_LOCALEDIR}")
    set(CMAKE_INSTALL_FULL_LOCALEDIR
        "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LOCALEDIR}")
else()
    set(CMAKE_INSTALL_FULL_LOCALEDIR "${CMAKE_INSTALL_LOCALEDIR}")
endif()

# Compute absolute paths used in config.h macros
set(APL_DIR_PREFIX      "${CMAKE_INSTALL_PREFIX}")
set(APL_DIR_EXEC_PREFIX "${CMAKE_INSTALL_PREFIX}")
set(APL_DIR_BIN         "${CMAKE_INSTALL_FULL_BINDIR}")
set(APL_DIR_LIB         "${CMAKE_INSTALL_FULL_LIBDIR}")
set(APL_DIR_DATAROOTDIR "${CMAKE_INSTALL_FULL_DATAROOTDIR}")
set(APL_DIR_DOC         "${CMAKE_INSTALL_FULL_DOCDIR}")
set(APL_DIR_LOCALE      "${CMAKE_INSTALL_FULL_LOCALEDIR}")
set(APL_DIR_SYSCONF     "${CMAKE_INSTALL_FULL_SYSCONFDIR}")
set(APL_DIR_PKGLIB      "${CMAKE_INSTALL_FULL_LIBDIR}/apl")
set(APL_DIR_SRC         "${CMAKE_SOURCE_DIR}/src")

# ---------------------------------------------------------------------------
# User options and platform checks
# ---------------------------------------------------------------------------
include(cmake/AplOptions.cmake)
include(cmake/AplHost.cmake)
include(cmake/AplChecks.cmake)

# ---------------------------------------------------------------------------
# Build metadata for BUILDTAG / ARCHIVE_SVN
# ---------------------------------------------------------------------------
string(TIMESTAMP APL_BUILD_DATE "%Y-%m-%d %H:%M:%S UTC" UTC)

cmake_host_system_information(RESULT _sys_name   QUERY OS_NAME)
cmake_host_system_information(RESULT _sys_proc   QUERY PROCESSOR_DESCRIPTION)
set(APL_BUILD_OS "${_sys_name} ${_sys_proc}")

# Reconstruct a summary of cmake invocation args (best-effort)
set(APL_CMAKE_ARGS "cmake -S . -B <builddir>")
set(APL_ARCHIVE_SVN "cmake")

# ---------------------------------------------------------------------------
# Generate config.h into the build directory
# ---------------------------------------------------------------------------
configure_file(
    "${CMAKE_SOURCE_DIR}/config.h.cmake.in"
    "${CMAKE_BINARY_DIR}/config.h"
    @ONLY
)
# Some source files use #include "../config.h" (relative to src/).
# That path resolves to the project root regardless of -I flags, so we
# also write config.h there.  config.h is generated output (like Makefile),
# not a hand-maintained source file; ./configure overwrites it anyway.
configure_file(
    "${CMAKE_SOURCE_DIR}/config.h.cmake.in"
    "${CMAKE_SOURCE_DIR}/config.h"
    @ONLY
)

# ---------------------------------------------------------------------------
# CTest (must come before add_subdirectory so BUILD_TESTING is set)
# ---------------------------------------------------------------------------
include(CTest)

# ---------------------------------------------------------------------------
# Subdirectories
# ---------------------------------------------------------------------------
add_subdirectory(src)

# ---------------------------------------------------------------------------
# Install: README and documentation files
# ---------------------------------------------------------------------------
set(_readme_files
    README
    README-1-prerequisites
    README-2-configure
    README-3-keyboard
    README-4-compliance
    README-5-WINDOWS
    README-6-porting
    README-7-more-info
    README-8-parallel
    README-9-post-installation
    README-10-python
    README-11-bogus-compiler-warnings
    README-12-vpath-builds
    README-13-build-pitfalls
)
foreach(_f ${_readme_files})
    if(EXISTS "${CMAKE_SOURCE_DIR}/${_f}")
        install(FILES "${CMAKE_SOURCE_DIR}/${_f}"
                DESTINATION "${CMAKE_INSTALL_DOCDIR}")
    endif()
endforeach()

# ---------------------------------------------------------------------------
# Install: preferences / sysconf
# ---------------------------------------------------------------------------
if(EXISTS "${CMAKE_SOURCE_DIR}/gnu-apl.d/preferences")
    install(FILES "${CMAKE_SOURCE_DIR}/gnu-apl.d/preferences"
            DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/gnu-apl.d")
endif()

# ---------------------------------------------------------------------------
# Install: APL workspace libraries
# ---------------------------------------------------------------------------
set(_pkglib "${APL_DIR_PKGLIB}")

# wslib3
foreach(_f
        wslib3/INVARIANTS.apl
        wslib3/meta.apl)
    if(EXISTS "${CMAKE_SOURCE_DIR}/${_f}")
        install(FILES "${CMAKE_SOURCE_DIR}/${_f}"
                DESTINATION "${_pkglib}/wslib3")
    endif()
endforeach()
if(IS_DIRECTORY "${CMAKE_SOURCE_DIR}/wslib3/DALY")
    install(DIRECTORY "${CMAKE_SOURCE_DIR}/wslib3/DALY/"
            DESTINATION "${_pkglib}/wslib3/DALY"
            FILES_MATCHING PATTERN "*.apl")
endif()

# wslib4
if(EXISTS "${CMAKE_SOURCE_DIR}/wslib4/dummy.apl")
    install(FILES "${CMAKE_SOURCE_DIR}/wslib4/dummy.apl"
            DESTINATION "${_pkglib}/wslib4")
endif()

# wslib5
foreach(_f
        wslib5/ASSERT.apl
        wslib5/FILE_IO.apl
        wslib5/FILE_IO1.apl
        wslib5/HTML.apl
        wslib5/ISO-13751.apl
        wslib5/SQL.apl)
    if(EXISTS "${CMAKE_SOURCE_DIR}/${_f}")
        install(FILES "${CMAKE_SOURCE_DIR}/${_f}"
                DESTINATION "${_pkglib}/wslib5")
    endif()
endforeach()
if(IS_DIRECTORY "${CMAKE_SOURCE_DIR}/wslib5/DALY")
    install(DIRECTORY "${CMAKE_SOURCE_DIR}/wslib5/DALY/"
            DESTINATION "${_pkglib}/wslib5/DALY"
            FILES_MATCHING PATTERN "*.apl")
endif()
if(IS_DIRECTORY "${CMAKE_SOURCE_DIR}/wslib5/iso-apl-cf")
    install(DIRECTORY "${CMAKE_SOURCE_DIR}/wslib5/iso-apl-cf/"
            DESTINATION "${_pkglib}/wslib5/iso-apl-cf"
            FILES_MATCHING PATTERN "*.apl")
endif()
if(IS_DIRECTORY "${CMAKE_SOURCE_DIR}/wslib5/APLComponentFiles")
    install(DIRECTORY "${CMAKE_SOURCE_DIR}/wslib5/APLComponentFiles/"
            DESTINATION "${_pkglib}/wslib5/APLComponentFiles"
            FILES_MATCHING PATTERN "*.apl")
endif()

# workspaces
if(IS_DIRECTORY "${CMAKE_SOURCE_DIR}/workspaces")
    install(DIRECTORY "${CMAKE_SOURCE_DIR}/workspaces/"
            DESTINATION "${_pkglib}/workspaces"
            FILES_MATCHING PATTERN "*.apl" PATTERN "*.xml")
endif()

# ---------------------------------------------------------------------------
# Doxygen custom target (optional)
# ---------------------------------------------------------------------------
find_package(Doxygen QUIET)
if(DOXYGEN_FOUND)
    add_custom_target(DOXY
        COMMAND ${DOXYGEN_EXECUTABLE} "${CMAKE_SOURCE_DIR}/Doxyfile"
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        COMMENT "Generating Doxygen documentation"
        VERBATIM
    )
endif()

# ---------------------------------------------------------------------------
# Configuration summary
# ---------------------------------------------------------------------------
include(cmake/AplConfigSummary.cmake)
