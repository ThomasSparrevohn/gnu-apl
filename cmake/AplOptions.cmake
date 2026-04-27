# cmake/AplOptions.cmake
# All user-visible CMake options for GNU APL.
# Corresponds to configure.ac AC_ARG_WITH / AC_ARG_VAR declarations.

# ---------------------------------------------------------------------------
# Master optional-libs switch (--with-optional_libs)
# ---------------------------------------------------------------------------
option(APL_WITH_OPTIONAL_LIBS "Enable optional libraries (FFT, PNG, PCRE, SQL, GUI...)" ON)

# ---------------------------------------------------------------------------
# Optional libraries (individual)
# ---------------------------------------------------------------------------
option(APL_WITH_FFT        "Enable FFTW3 (⎕FFT)"              ON)
option(APL_WITH_PNG        "Enable libpng (⎕PNG)"             ON)
option(APL_WITH_PCRE       "Enable PCRE2-32 regex (⎕RE)"      ON)
option(APL_WITH_SQLITE3    "Enable SQLite3 (⎕SQL)"            ON)
option(APL_WITH_POSTGRESQL "Enable PostgreSQL (⎕SQL)"         ON)
option(APL_WITH_GSL        "Enable GSL (⎕MX, ⌹[])"           ON)
option(APL_WITH_GTK3       "Enable GTK+ 3 (⎕GTK, ⎕PLOT)"     ON)
option(APL_WITH_X          "Enable X11/XCB (⎕PLOT)"           ON)

# Root/path overrides for libraries
set(APL_SQLITE3_ROOT       "" CACHE PATH    "Root directory of SQLite3 installation")
set(APL_PCRE_ROOT          "" CACHE PATH    "Root directory of PCRE2 installation")
set(APL_POSTGRESQL_PG_CONFIG "" CACHE FILEPATH "Path to pg_config for PostgreSQL")
set(APL_X_INCLUDE_DIR      "" CACHE PATH    "X11 include directory override")
set(APL_X_LIBRARY_DIR      "" CACHE PATH    "X11 library directory override")

# ---------------------------------------------------------------------------
# Build targets
# ---------------------------------------------------------------------------
option(APL_WITH_ANDROID    "Compile for Android"                OFF)
option(APL_WITH_ERLANG     "Build Erlang interface (implies libapl)" OFF)
option(APL_WITH_LIBAPL     "Build libapl shared library"        OFF)
option(APL_WITH_PYTHON     "Build Python extension lib_gnu_apl" OFF)

# Erlang implies libapl
if(APL_WITH_ERLANG AND NOT APL_WITH_LIBAPL)
    set(APL_WITH_LIBAPL ON CACHE BOOL "Build libapl shared library" FORCE)
endif()

# ---------------------------------------------------------------------------
# Misc build options
# ---------------------------------------------------------------------------
option(APL_WITH_CTRLD_DEL  "Use ^D as delete-char, ^Z as EOF"  OFF)

# ---------------------------------------------------------------------------
# Development / tuning variables
# Prefer APL_* names; also accept legacy environment-variable names for
# transition (set via -DOLD_NAME=... on the cmake command line).
# ---------------------------------------------------------------------------

# Helper macro: inherit old env-var name if set, otherwise use new default
macro(_apl_inherit_option NEW_NAME OLD_NAME TYPE DOCSTRING DEFAULT)
    if(DEFINED ENV{${OLD_NAME}} AND NOT DEFINED ${NEW_NAME})
        set(${NEW_NAME} "$ENV{${OLD_NAME}}" CACHE ${TYPE} "${DOCSTRING}")
    else()
        set(${NEW_NAME} "${DEFAULT}" CACHE ${TYPE} "${DOCSTRING}")
    endif()
endmacro()

_apl_inherit_option(APL_CXX_WERROR        CXX_WERROR                   BOOL   "Turn all warnings into errors (-Werror)" OFF)
_apl_inherit_option(APL_DEVELOP           DEVELOP_WANTED               BOOL   "Development mode (implies high assert/log/check)" OFF)
_apl_inherit_option(APL_MAX_RANK          MAX_RANK_WANTED              STRING "Maximum rank of APL values" 8)
_apl_inherit_option(APL_ALT_MAP           ALT_MAP_WANTED               STRING "Alt-key map profile (0=none)" 0)
_apl_inherit_option(APL_VALUE_CHECK       VALUE_CHECK_WANTED           BOOL   "Enable Value::check_value()" OFF)
_apl_inherit_option(APL_PERFORMANCE_COUNTERS PERFORMANCE_COUNTERS_WANTED BOOL "Enable performance counters" OFF)
_apl_inherit_option(APL_VALUE_HISTORY     VALUE_HISTORY_WANTED         BOOL   "Enable value history (debug)" OFF)
_apl_inherit_option(APL_GPROF             GPROF_WANTED                 BOOL   "Enable gprof profiling (-pg)" OFF)
_apl_inherit_option(APL_GCOV             GCOV_WANTED                  BOOL   "Enable gcov coverage (--coverage)" OFF)
_apl_inherit_option(APL_DYNAMIC_LOG       DYNAMIC_LOG_WANTED           BOOL   "Enable dynamic logging" OFF)
_apl_inherit_option(APL_VF_TRACING        VF_TRACING_WANTED            BOOL   "Enable value-flag tracing" OFF)
_apl_inherit_option(APL_ASSERT_LEVEL      ASSERT_LEVEL_WANTED          STRING "Assert level (0=none 1=some 2=all)" 1)
_apl_inherit_option(APL_SECURITY_LEVEL    SECURITY_LEVEL_WANTED        STRING "Security level (0-2)" 0)
_apl_inherit_option(APL_CORE_COUNT        CORE_COUNT_WANTED            STRING "CPU cores to use (0=auto)" 0)
_apl_inherit_option(APL_APSERVER_TRANSPORT APSERVER_TRANSPORT          STRING "APserver socket type (TCP|LINUX|UNIX)" "TCP")
_apl_inherit_option(APL_APSERVER_PORT     APSERVER_PORT                STRING "APserver TCP port" 16366)
_apl_inherit_option(APL_APSERVER_PATH     APSERVER_PATH                STRING "APserver Unix-socket path" "/tmp/GNU-APL/APserver")
_apl_inherit_option(APL_SHORT_VALUE_LENGTH SHORT_VALUE_LENGTH_WANTED   STRING "Max cell-count of short values" 12)
_apl_inherit_option(APL_VISIBLE_MARKERS   VISIBLE_MARKERS_WANTED       BOOL   "Enable visible formatting markers (debug)" OFF)
_apl_inherit_option(APL_RATIONAL_NUMBERS  RATIONAL_NUMBERS_WANTED      BOOL   "Enable rational number support (EXPERIMENTAL)" OFF)

# DEVELOP_WANTED implies certain sub-options (mirror Autotools behaviour)
if(APL_DEVELOP)
    if(NOT DEFINED CACHE{APL_ASSERT_LEVEL} OR "${APL_ASSERT_LEVEL}" STREQUAL "1")
        set(APL_ASSERT_LEVEL 2 CACHE STRING "Assert level (0=none 1=some 2=all)" FORCE)
    endif()
    if(NOT APL_DYNAMIC_LOG)
        set(APL_DYNAMIC_LOG ON CACHE BOOL "Enable dynamic logging" FORCE)
    endif()
    if(NOT APL_PERFORMANCE_COUNTERS)
        set(APL_PERFORMANCE_COUNTERS ON CACHE BOOL "Enable performance counters" FORCE)
    endif()
    if(NOT APL_VALUE_CHECK)
        set(APL_VALUE_CHECK ON CACHE BOOL "Enable Value::check_value()" FORCE)
    endif()
    if(NOT APL_VALUE_HISTORY)
        set(APL_VALUE_HISTORY ON CACHE BOOL "Enable value history (debug)" FORCE)
    endif()
endif()

# Translate APSERVER_TRANSPORT string → integer (0=TCP, 1=LINUX, 2=UNIX)
if("${APL_APSERVER_TRANSPORT}" STREQUAL "" OR "${APL_APSERVER_TRANSPORT}" STREQUAL "TCP")
    set(_cfg_APSERVER_TRANSPORT 0)
elseif("${APL_APSERVER_TRANSPORT}" STREQUAL "LINUX")
    set(_cfg_APSERVER_TRANSPORT 1)
elseif("${APL_APSERVER_TRANSPORT}" STREQUAL "UNIX")
    set(_cfg_APSERVER_TRANSPORT 2)
else()
    set(_cfg_APSERVER_TRANSPORT 0)
endif()

# Program name prefix/suffix  (analogous to --program-prefix / --program-suffix)
set(APL_PROGRAM_PREFIX "" CACHE STRING "Prefix added to installed program name")
set(APL_PROGRAM_SUFFIX "" CACHE STRING "Suffix added to installed program name")
set(APL_EXECUTABLE_NAME "${APL_PROGRAM_PREFIX}apl${APL_PROGRAM_SUFFIX}")
