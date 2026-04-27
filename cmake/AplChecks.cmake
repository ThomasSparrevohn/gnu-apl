# cmake/AplChecks.cmake
# Platform feature detection and optional library discovery for GNU APL.
# Results are stored in variables that configure_file() maps into config.h.
#
# IMPORTANT: Do NOT pre-set HAVE_* variables before calling CMake check_*
# functions; those functions skip their tests when the result variable is
# already defined in any scope.

include(CheckIncludeFileCXX)
include(CheckFunctionExists)
include(CheckLibraryExists)
include(CheckSymbolExists)
include(CheckStructHasMember)
include(CheckCXXSourceCompiles)
include(CheckCXXCompilerFlag)
find_package(PkgConfig QUIET)

# ---------------------------------------------------------------------------
# Pre-initialise ONLY APL feature flags and cfg_ booleans (not HAVE_* vars).
# #cmakedefine01 in config.h.cmake.in handles undefined HAVE_* as 0 safely.
# ---------------------------------------------------------------------------
foreach(_v
    apl_FFT apl_GUI apl_GSL apl_GTK3 apl_PCRE apl_PNG
    apl_POSTGRES apl_SQLITE3 apl_X11 apl_XCB
    apl_TARGET_ANDROID apl_TARGET_ERLANG apl_TARGET_LIBAPL apl_TARGET_PYTHON
    HAVE_LIBFFTW3 HAVE_LIBGSL HAVE_LIBGSLCBLAS HAVE_LIBGTK_3 HAVE_LIBGDK_3
    HAVE_LIBCAIRO HAVE_LIBPCRE2_32 HAVE_LIBPNG HAVE_LIBX11 HAVE_LIBX11_XCB
    HAVE_LIBXCB HAVE_POSTGRESQL HAVE_SQLITE3
    HAVE_X11_XLIB_H HAVE_X11_XLIB_XCB_H HAVE_X11_XUTIL_H HAVE_X11_XKBLIB_H
    HAVE_XCB_XCB_H
    HAVE_LIBATOMICITY HAVE_LIBC HAVE_LIBCURSES HAVE_LIBDL HAVE_LIBM
    HAVE_LIBNCURSES HAVE_LIBNSL HAVE_LIBPTHREAD HAVE_LIBSOCKET HAVE_LIBTINFO HAVE_LIBZ
    HAVE_WORKING_FORK HAVE_WORKING_VFORK
    HAVE_STRUCT_STAT_ST_BLOCKS HAVE_ST_BLOCKS HAVE_STAT_ST_BLKSIZE_STAT_ST_RDEV
    cfg_WANT_CTRLD_DEL cfg_DEVELOP_WANTED cfg_VALUE_CHECK_WANTED
    cfg_PERFORMANCE_COUNTERS_WANTED cfg_VALUE_HISTORY_WANTED
    cfg_DYNAMIC_LOG_WANTED cfg_VF_TRACING_WANTED
    cfg_VISIBLE_MARKERS_WANTED cfg_RATIONAL_NUMBERS_WANTED
    cfg_USER_WANTS_SQLITE3 cfg_USER_WANTS_POSTGRES
    MINGW_SRC STDC_HEADERS
)
    set(${_v} 0)
endforeach()

# STDC_HEADERS is always 1 on modern systems
set(STDC_HEADERS 1)

# ---------------------------------------------------------------------------
# Header checks (results stored in cache by check_include_file_cxx)
# ---------------------------------------------------------------------------
check_include_file_cxx("ncurses.h"         HAVE_NCURSES_H)
if(NOT HAVE_NCURSES_H)
    check_include_file_cxx("curses.h"      HAVE_CURSES_H)
endif()
check_include_file_cxx("term.h"            HAVE_TERM_H)
check_include_file_cxx("dirent.h"          HAVE_DIRENT_H)
check_include_file_cxx("dlfcn.h"           HAVE_DLFCN_H)
check_include_file_cxx("execinfo.h"        HAVE_EXECINFO_H)
check_include_file_cxx("ext/atomicity.h"   HAVE_EXT_ATOMICITY_H)
check_include_file_cxx("fcntl.h"           HAVE_FCNTL_H)
check_include_file_cxx("fenv.h"            HAVE_FENV_H)
check_include_file_cxx("fftw3.h"           HAVE_FFTW3_H)
check_include_file_cxx("inttypes.h"        HAVE_INTTYPES_H)
check_include_file_cxx("limits.h"          HAVE_LIMITS_H)
check_include_file_cxx("locale.h"          HAVE_LOCALE_H)
check_include_file_cxx("malloc.h"          HAVE_MALLOC_H)
check_include_file_cxx("netdb.h"           HAVE_NETDB_H)
check_include_file_cxx("netinet/in.h"      HAVE_NETINET_IN_H)
check_include_file_cxx("netinet/tcp.h"     HAVE_NETINET_TCP_H)
check_include_file_cxx("stdint.h"          HAVE_STDINT_H)
check_include_file_cxx("stdio.h"           HAVE_STDIO_H)
check_include_file_cxx("stdlib.h"          HAVE_STDLIB_H)
check_include_file_cxx("stdbool.h"         HAVE_STDBOOL_H)
check_include_file_cxx("string.h"          HAVE_STRING_H)
check_include_file_cxx("strings.h"         HAVE_STRINGS_H)
check_include_file_cxx("sys/fcntl.h"       HAVE_SYS_FCNTL_H)
check_include_file_cxx("sys/ioctl.h"       HAVE_SYS_IOCTL_H)
check_include_file_cxx("sys/mman.h"        HAVE_SYS_MMAN_H)
check_include_file_cxx("sys/param.h"       HAVE_SYS_PARAM_H)
check_include_file_cxx("sys/resource.h"    HAVE_SYS_RESOURCE_H)
check_include_file_cxx("sys/select.h"      HAVE_SYS_SELECT_H)
check_include_file_cxx("sys/socket.h"      HAVE_SYS_SOCKET_H)
check_include_file_cxx("sys/stat.h"        HAVE_SYS_STAT_H)
check_include_file_cxx("sys/time.h"        HAVE_SYS_TIME_H)
check_include_file_cxx("sys/types.h"       HAVE_SYS_TYPES_H)
check_include_file_cxx("sys/un.h"          HAVE_SYS_UN_H)
check_include_file_cxx("sys/wait.h"        HAVE_SYS_WAIT_H)
check_include_file_cxx("termios.h"         HAVE_TERMIOS_H)
check_include_file_cxx("unistd.h"          HAVE_UNISTD_H)
check_include_file_cxx("utmpx.h"           HAVE_UTMPX_H)
check_include_file_cxx("zlib.h"            HAVE_ZLIB_H)
check_include_file_cxx("windows.h"         HAVE_WINDOWS_H)
check_include_file_cxx("winsock2.h"        HAVE_WINSOCK2_H)
check_include_file_cxx("wchar.h"           HAVE_WCHAR_H)
check_include_file_cxx("libpng16/png.h"    HAVE_LIBPNG16_PNG_H)
check_include_file_cxx("vector"            HAVE_VECTOR)

# ---------------------------------------------------------------------------
# struct stat member checks
# ---------------------------------------------------------------------------
check_struct_has_member("struct stat" st_blocks "sys/stat.h" HAVE_STRUCT_STAT_ST_BLOCKS)
if(HAVE_STRUCT_STAT_ST_BLOCKS)
    set(HAVE_ST_BLOCKS 1)
endif()
check_struct_has_member("struct stat" st_blksize "sys/stat.h" _HAVE_ST_BLKSIZE)
check_struct_has_member("struct stat" st_rdev    "sys/stat.h" _HAVE_ST_RDEV)
if(_HAVE_ST_BLKSIZE AND _HAVE_ST_RDEV)
    set(HAVE_STAT_ST_BLKSIZE_STAT_ST_RDEV 1)
endif()

# ---------------------------------------------------------------------------
# Function checks
# ---------------------------------------------------------------------------
check_symbol_exists(alarm       "unistd.h"              HAVE_ALARM)
check_symbol_exists(dup2        "unistd.h"              HAVE_DUP2)
check_symbol_exists(floor       "math.h"                HAVE_FLOOR)
check_symbol_exists(fork        "unistd.h"              HAVE_FORK)
check_symbol_exists(getcwd      "unistd.h"              HAVE_GETCWD)
check_symbol_exists(gethostbyname "netdb.h"             HAVE_GETHOSTBYNAME)
check_symbol_exists(getpagesize "unistd.h"              HAVE_GETPAGESIZE)
check_symbol_exists(malloc      "stdlib.h"              HAVE_MALLOC)
check_symbol_exists(memset      "string.h"              HAVE_MEMSET)
check_symbol_exists(mkdir       "sys/stat.h"            HAVE_MKDIR)
check_symbol_exists(modf        "math.h"                HAVE_MODF)
check_symbol_exists(mmap        "sys/mman.h"            HAVE_MMAP)
check_symbol_exists(munmap      "sys/mman.h"            HAVE_MUNMAP)
check_symbol_exists(pow         "math.h"                HAVE_POW)
check_symbol_exists(realpath    "stdlib.h"              HAVE_REALPATH)
check_symbol_exists(rint        "math.h"                HAVE_RINT)
check_symbol_exists(rmdir       "unistd.h"              HAVE_RMDIR)
check_symbol_exists(select      "sys/select.h"          HAVE_SELECT)
check_symbol_exists(setenv      "stdlib.h"              HAVE_SETENV)
check_symbol_exists(setlocale   "locale.h"              HAVE_SETLOCALE)
check_symbol_exists(socket      "sys/socket.h"          HAVE_SOCKET)
check_symbol_exists(sqrt        "math.h"                HAVE_SQRT)
check_symbol_exists(strcasecmp  "strings.h"             HAVE_STRCASECMP)
check_symbol_exists(strchr      "string.h"              HAVE_STRCHR)
check_symbol_exists(strdup      "string.h"              HAVE_STRDUP)
check_symbol_exists(strerror    "string.h"              HAVE_STRERROR)
check_symbol_exists(strncasecmp "strings.h"             HAVE_STRNCASECMP)
check_symbol_exists(strndup     "string.h"              HAVE_STRNDUP)
check_symbol_exists(strrchr     "string.h"              HAVE_STRRCHR)
check_symbol_exists(strstr      "string.h"              HAVE_STRSTR)
check_symbol_exists(strtol      "stdlib.h"              HAVE_STRTOL)
check_symbol_exists(uname       "sys/utsname.h"         HAVE_UNAME)
check_symbol_exists(vfork       "unistd.h"              HAVE_VFORK)

if(HAVE_FORK)
    set(HAVE_WORKING_FORK 1)
endif()
if(HAVE_VFORK)
    set(HAVE_WORKING_VFORK 1)
endif()

# ---------------------------------------------------------------------------
# Library checks
# ---------------------------------------------------------------------------
find_library(_LIB_TINFO   tinfo)
find_library(_LIB_SOCKET  socket)
find_library(_LIB_NSL     nsl)
find_library(_LIB_M       m)
find_library(_LIB_DL      dl)
find_library(_LIB_PTHREAD pthread)
find_library(_LIB_NCURSES ncurses)
find_library(_LIB_CURSES  curses)
find_library(_LIB_Z       z)

if(_LIB_TINFO)
    set(HAVE_LIBTINFO 1)
endif()
if(_LIB_SOCKET)
    set(HAVE_LIBSOCKET 1)
endif()
if(_LIB_NSL)
    set(HAVE_LIBNSL 1)
endif()
if(_LIB_M)
    set(HAVE_LIBM 1)
endif()
if(_LIB_DL)
    set(HAVE_LIBDL 1)
endif()
if(_LIB_PTHREAD)
    set(HAVE_LIBPTHREAD 1)
endif()
if(_LIB_NCURSES)
    set(HAVE_LIBNCURSES 1)
endif()
if(_LIB_CURSES)
    set(HAVE_LIBCURSES 1)
endif()
if(_LIB_Z)
    set(HAVE_LIBZ 1)
endif()

# Collect required link libraries
set(APL_REQUIRED_LIBS "")
if(_LIB_M)
    list(APPEND APL_REQUIRED_LIBS m)
endif()
if(_LIB_DL)
    list(APPEND APL_REQUIRED_LIBS dl)
endif()
if(_LIB_PTHREAD)
    list(APPEND APL_REQUIRED_LIBS pthread)
endif()
if(_LIB_NCURSES)
    list(APPEND APL_REQUIRED_LIBS ncurses)
elseif(_LIB_CURSES)
    list(APPEND APL_REQUIRED_LIBS curses)
endif()
if(_LIB_TINFO)
    list(APPEND APL_REQUIRED_LIBS tinfo)
endif()

# ---------------------------------------------------------------------------
# Special compile-time checks
# ---------------------------------------------------------------------------

# rdtsc – Intel CPU cycle counter
check_cxx_source_compiles("
int main(){
    unsigned int lo, hi;
    __asm__ __volatile__ (\"rdtsc\" : \"=a\" (lo), \"=d\" (hi));
    return 0;
}" HAVE_RDTSC)

# gettimeofday compile check
check_cxx_source_compiles("
#include <sys/time.h>
int main(){ timeval tv; gettimeofday(&tv, 0); return 0; }
" HAVE_GETTIMEOFDAY)

# sem_init() – does not work on macOS
check_cxx_source_compiles("
#include <semaphore.h>
int main(){ sem_t s; sem_init(&s, 0, 0); return 0; }
" HAVE_SEM_INIT)

# TIOCGWINSZ ioctl
check_cxx_source_compiles("
#include <sys/ioctl.h>
int main(){ winsize win; ioctl(0, TIOCGWINSZ, &win); return 0; }
" HAVE_IOCTL_TIOCGWINSZ)

# pthread_setname_np
check_cxx_source_compiles("
#include <pthread.h>
int main(){ pthread_t t = 0; pthread_setname_np(t, \"x\"); return 0; }
" HAVE_PTHREAD_SETNAME_NP)

# pthread_setaffinity_np + ext/atomicity.h
check_cxx_source_compiles("
#include <pthread.h>
#include <ext/atomicity.h>
int main(){
    cpu_set_t s;
    pthread_setaffinity_np(0, sizeof(s), &s);
    pthread_getaffinity_np(0, sizeof(s), &s);
    _Atomic_word c = 0;
    __gnu_cxx::__exchange_and_add_dispatch(&c, 1);
    __gnu_cxx::__atomic_add_dispatch(&c, 1);
    return 0;
}" HAVE_AFFINITY_NP)

# OSAtomicAdd32Barrier – macOS
check_cxx_source_compiles("
#include <libkern/OSAtomic.h>
int main(){ OSAtomicAdd32Barrier(0, 0); return 0; }
" HAVE_OSX_ATOMIC)

# atomic_add_32_nv – Solaris
check_cxx_source_compiles("
#include <atomic.h>
int main(){ atomic_add_32_nv(0, 0); atomic_add_32(0, 0); return 0; }
" HAVE_SOLARIS_ATOMIC)

# initstate_r → HAVE_LIBC
check_cxx_source_compiles("
#include <stdlib.h>
int main(){
    struct random_data buf = {};
    char state[128];
    initstate_r(0, state, sizeof(state), &buf);
    return 0;
}" HAVE_LIBC)

# ---------------------------------------------------------------------------
# APL feature macros derived from build options
# ---------------------------------------------------------------------------
if(APL_WITH_ANDROID)
    set(apl_TARGET_ANDROID 1)
endif()
if(APL_WITH_ERLANG)
    set(apl_TARGET_ERLANG 1)
endif()
if(APL_WITH_LIBAPL)
    set(apl_TARGET_LIBAPL 1)
endif()
if(APL_WITH_PYTHON)
    set(apl_TARGET_PYTHON 1)
endif()
if(APL_WITH_CTRLD_DEL)
    set(cfg_WANT_CTRLD_DEL 1)
endif()

# cfg_ boolean macros from APL_ options
if(APL_DEVELOP)
    set(cfg_DEVELOP_WANTED 1)
endif()
if(APL_VALUE_CHECK)
    set(cfg_VALUE_CHECK_WANTED 1)
endif()
if(APL_PERFORMANCE_COUNTERS)
    set(cfg_PERFORMANCE_COUNTERS_WANTED 1)
endif()
if(APL_VALUE_HISTORY)
    set(cfg_VALUE_HISTORY_WANTED 1)
endif()
if(APL_DYNAMIC_LOG)
    set(cfg_DYNAMIC_LOG_WANTED 1)
endif()
if(APL_VF_TRACING)
    set(cfg_VF_TRACING_WANTED 1)
endif()
if(APL_VISIBLE_MARKERS)
    set(cfg_VISIBLE_MARKERS_WANTED 1)
endif()
if(APL_RATIONAL_NUMBERS)
    set(cfg_RATIONAL_NUMBERS_WANTED 1)
endif()

# ---------------------------------------------------------------------------
# MINGW check
# ---------------------------------------------------------------------------
if(WIN32 AND MINGW)
    set(MINGW_SRC 1)
endif()

# ---------------------------------------------------------------------------
# Optional libraries
# ---------------------------------------------------------------------------
if(NOT APL_WITH_OPTIONAL_LIBS)
    message(STATUS "APL: optional libraries disabled (APL_WITH_OPTIONAL_LIBS=OFF)")
else()

# --- FFT (fftw3) -----------------------------------------------------------
if(APL_WITH_FFT)
    if(PKG_CONFIG_FOUND)
        pkg_check_modules(FFTW3 QUIET libfftw3)
    endif()
    if(NOT FFTW3_FOUND)
        find_library(_fftw3_lib fftw3)
        find_path(_fftw3_inc fftw3.h)
        if(_fftw3_lib AND _fftw3_inc)
            set(FFTW3_FOUND TRUE)
            set(FFTW3_LIBRARIES "${_fftw3_lib}")
            set(FFTW3_INCLUDE_DIRS "${_fftw3_inc}")
        endif()
    endif()
    if(FFTW3_FOUND)
        set(apl_FFT 1)
        set(HAVE_LIBFFTW3 1)
        message(STATUS "APL: FFT (fftw3) found")
    else()
        message(STATUS "APL: FFT (fftw3) NOT found – ⎕FFT unavailable")
    endif()
endif()

# --- PNG (libpng) ----------------------------------------------------------
if(APL_WITH_PNG)
    find_package(PNG QUIET)
    if(PNG_FOUND)
        set(apl_PNG 1)
        set(HAVE_LIBPNG 1)
        message(STATUS "APL: PNG (libpng) found")
    else()
        message(STATUS "APL: PNG (libpng) NOT found – ⎕PNG affected")
    endif()
endif()

# --- GSL ------------------------------------------------------------------
if(APL_WITH_GSL)
    find_package(GSL QUIET)
    if(GSL_FOUND)
        check_library_exists("${GSL_LIBRARIES}" gsl_linalg_QL_decomp "" _GSL_HAS_QL)
        if(_GSL_HAS_QL)
            set(apl_GSL 1)
            set(HAVE_LIBGSL 1)
            set(HAVE_LIBGSLCBLAS 1)
            message(STATUS "APL: GSL found (≥2.7)")
        else()
            message(STATUS "APL: GSL found but too old (need ≥2.7) – ⎕MX affected")
        endif()
    else()
        message(STATUS "APL: GSL NOT found – ⎕MX affected")
    endif()
endif()

# --- PCRE2-32 -------------------------------------------------------------
if(APL_WITH_PCRE)
    set(_pcre_found FALSE)
    if(APL_PCRE_ROOT)
        find_library(_pcre2_32_lib pcre2-32
            PATHS "${APL_PCRE_ROOT}/lib" "${APL_PCRE_ROOT}/lib64"
            NO_DEFAULT_PATH)
        find_path(_pcre2_32_inc pcre2.h
            PATHS "${APL_PCRE_ROOT}/include"
            NO_DEFAULT_PATH)
        if(_pcre2_32_lib AND _pcre2_32_inc)
            set(_pcre_found TRUE)
            set(_pcre2_32_libs "${_pcre2_32_lib}")
            set(_pcre2_32_incs "${_pcre2_32_inc}")
        endif()
    endif()
    if(NOT _pcre_found AND PKG_CONFIG_FOUND)
        pkg_check_modules(PCRE2_32 QUIET libpcre2-32)
        if(PCRE2_32_FOUND)
            set(_pcre_found TRUE)
            set(_pcre2_32_libs "${PCRE2_32_LIBRARIES}")
            set(_pcre2_32_incs "${PCRE2_32_INCLUDE_DIRS}")
            set(_pcre2_32_ldirs "${PCRE2_32_LIBRARY_DIRS}")
        endif()
    endif()
    if(NOT _pcre_found)
        find_library(_pcre2_32_lib pcre2-32)
        find_path(_pcre2_32_inc pcre2.h)
        if(_pcre2_32_lib AND _pcre2_32_inc)
            set(_pcre_found TRUE)
            set(_pcre2_32_libs "${_pcre2_32_lib}")
            set(_pcre2_32_incs "${_pcre2_32_inc}")
        endif()
    endif()
    if(_pcre_found)
        set(apl_PCRE 1)
        set(HAVE_LIBPCRE2_32 1)
        set(APL_PCRE2_LIBRARIES "${_pcre2_32_libs}")
        set(APL_PCRE2_INCLUDE_DIRS "${_pcre2_32_incs}")
        if(DEFINED _pcre2_32_ldirs)
            set(APL_PCRE2_LIBRARY_DIRS "${_pcre2_32_ldirs}")
        endif()
        message(STATUS "APL: PCRE2-32 found – ⎕RE available")
    else()
        message(STATUS "APL: PCRE2-32 NOT found – ⎕RE unavailable")
    endif()
endif()

# --- SQLite3 --------------------------------------------------------------
if(APL_WITH_SQLITE3)
    if(APL_SQLITE3_ROOT)
        find_library(_sqlite3_lib sqlite3
            PATHS "${APL_SQLITE3_ROOT}/lib" "${APL_SQLITE3_ROOT}/lib64"
            NO_DEFAULT_PATH)
        find_path(_sqlite3_inc sqlite3.h
            PATHS "${APL_SQLITE3_ROOT}/include"
            NO_DEFAULT_PATH)
        if(_sqlite3_lib AND _sqlite3_inc)
            set(APL_SQLITE3_LIBRARIES "${_sqlite3_lib}")
            set(APL_SQLITE3_INCLUDE_DIRS "${_sqlite3_inc}")
            set(SQLite3_FOUND TRUE)
        endif()
    endif()
    if(NOT SQLite3_FOUND)
        find_package(SQLite3 QUIET)
        if(SQLite3_FOUND)
            set(APL_SQLITE3_LIBRARIES "${SQLite3_LIBRARIES}")
            set(APL_SQLITE3_INCLUDE_DIRS "${SQLite3_INCLUDE_DIRS}")
        endif()
    endif()
    if(SQLite3_FOUND)
        set(apl_SQLITE3 1)
        set(HAVE_SQLITE3 1)
        set(cfg_USER_WANTS_SQLITE3 1)
        message(STATUS "APL: SQLite3 found – ⎕SQL available")
    else()
        message(STATUS "APL: SQLite3 NOT found – ⎕SQL may be unavailable")
    endif()
endif()

# --- PostgreSQL -----------------------------------------------------------
if(APL_WITH_POSTGRESQL)
    if(APL_POSTGRESQL_PG_CONFIG)
        set(PostgreSQL_ADDITIONAL_SEARCH_PATHS "${APL_POSTGRESQL_PG_CONFIG}")
    endif()
    find_package(PostgreSQL QUIET)
    if(PostgreSQL_FOUND)
        set(apl_POSTGRES 1)
        set(HAVE_POSTGRESQL 1)
        set(cfg_USER_WANTS_POSTGRES 1)
        set(APL_POSTGRESQL_INCLUDE_DIRS "${PostgreSQL_INCLUDE_DIRS}")
        set(APL_POSTGRESQL_LIBRARIES    "${PostgreSQL_LIBRARIES}")
        message(STATUS "APL: PostgreSQL found – ⎕SQL available")
    else()
        message(STATUS "APL: PostgreSQL NOT found – ⎕SQL may be unavailable")
    endif()
endif()

# --- GTK3 ----------------------------------------------------------------
if(APL_WITH_GTK3)
    if(PKG_CONFIG_FOUND)
        pkg_check_modules(GTK3 QUIET gtk+-3.0)
        if(GTK3_FOUND)
            set(apl_GTK3 1)
            set(HAVE_LIBGTK_3 1)
            set(HAVE_LIBGDK_3 1)
            set(HAVE_LIBCAIRO 1)
            message(STATUS "APL: GTK3 found – ⎕GTK/⎕PLOT/⎕PNG available")
        else()
            message(STATUS "APL: GTK3 NOT found via pkg-config – ⎕GTK affected")
        endif()
    else()
        message(STATUS "APL: pkg-config not found, skipping GTK3 detection")
    endif()
endif()

# --- X11/XCB -------------------------------------------------------------
if(APL_WITH_X)
    set(_x11_ok TRUE)

    if(APL_X_INCLUDE_DIR OR APL_X_LIBRARY_DIR)
        find_library(_x11_lib  X11 PATHS "${APL_X_LIBRARY_DIR}" NO_DEFAULT_PATH)
        find_library(_xcb_lib  xcb PATHS "${APL_X_LIBRARY_DIR}" NO_DEFAULT_PATH)
        find_library(_x11xcb_lib X11-xcb PATHS "${APL_X_LIBRARY_DIR}" NO_DEFAULT_PATH)
        set(X11_INCLUDE_DIR "${APL_X_INCLUDE_DIR}")
        set(X11_FOUND TRUE)
    else()
        find_package(X11 QUIET)
        find_library(_xcb_lib    xcb)
        find_library(_x11xcb_lib X11-xcb)
    endif()

    # Required headers for Plot_xcb.cc
    foreach(_xhdr
            "xcb/xcb.h" "X11/Xlib.h" "X11/Xlib-xcb.h"
            "X11/Xutil.h" "X11/XKBlib.h")
        check_include_file_cxx("${_xhdr}" _xhdr_found)
        if(NOT _xhdr_found)
            set(_x11_ok FALSE)
        endif()
        unset(_xhdr_found CACHE)
    endforeach()

    if(NOT X11_FOUND OR NOT _xcb_lib OR NOT _x11xcb_lib)
        set(_x11_ok FALSE)
    endif()

    if(_x11_ok)
        set(apl_X11 1)
        set(apl_XCB 1)
        set(HAVE_LIBX11 1)
        set(HAVE_LIBXCB 1)
        set(HAVE_LIBX11_XCB 1)
        set(HAVE_X11_XLIB_H 1)
        set(HAVE_X11_XLIB_XCB_H 1)
        set(HAVE_X11_XUTIL_H 1)
        set(HAVE_X11_XKBLIB_H 1)
        set(HAVE_XCB_XCB_H 1)
        set(APL_XCB_LIBRARIES "${X11_LIBRARIES}" "${_xcb_lib}" "${_x11xcb_lib}")
        message(STATUS "APL: X11/XCB found – ⎕PLOT available")
    else()
        message(STATUS "APL: X11/XCB NOT fully found – ⎕PLOT may use ASCII fallback")
    endif()
endif()

endif() # APL_WITH_OPTIONAL_LIBS

# ---------------------------------------------------------------------------
# Derived feature flags
# ---------------------------------------------------------------------------
if(apl_GTK3 OR apl_XCB)
    set(apl_GUI 1)
endif()

# ---------------------------------------------------------------------------
# Compiler flag options
# ---------------------------------------------------------------------------
if(APL_CXX_WERROR)
    check_cxx_compiler_flag(-Werror _has_werror)
    if(_has_werror)
        set(APL_WERROR_FLAG "-Werror")
    endif()
else()
    set(APL_WERROR_FLAG "")
endif()

if(APL_GPROF)
    set(APL_GPROF_FLAGS "-pg")
else()
    set(APL_GPROF_FLAGS "")
endif()

if(APL_GCOV)
    set(APL_GCOV_FLAGS "--coverage")
else()
    set(APL_GCOV_FLAGS "")
endif()
