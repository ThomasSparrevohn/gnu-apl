# src/APs/CMakeLists.txt
# Builds APserver, AP100, and AP210 — the auxiliary processors for GNU APL's
# shared-variable subsystem. These must live alongside (or in APs/ next to)
# the apl binary so that Svar_DB::start_APserver() and launch_AP() can find them.

set(AP_COMMON_SOURCES
    APmain.cc
    ../Backtrace.cc
    ../Svar_DB.cc
    ../Svar_record.cc
)

# Common include dirs and flags shared by all three targets.
function(ap_target_setup name)
    target_include_directories(${name}
        PRIVATE
            "${CMAKE_CURRENT_SOURCE_DIR}/.."  # src/ — picks up Common.hh etc.
            "${CMAKE_BINARY_DIR}"             # generated config.h (as "config.h")
            "${CMAKE_SOURCE_DIR}"             # project root — for <config.h>
    )
    target_compile_features(${name} PRIVATE cxx_std_17)
    target_compile_options(${name} PRIVATE -Wall -Wno-strict-aliasing)
endfunction()

# ---------------------------------------------------------------------------
# AP100 — OS command-execution auxiliary processor
# ---------------------------------------------------------------------------
add_executable(AP100
    AP100.cc
    ${AP_COMMON_SOURCES}
)
ap_target_setup(AP100)
target_compile_definitions(AP100 PRIVATE AP_NUM=100)

# ---------------------------------------------------------------------------
# AP210 — file I/O auxiliary processor
# ---------------------------------------------------------------------------
add_executable(AP210
    AP210.cc
    ${AP_COMMON_SOURCES}
)
ap_target_setup(AP210)
target_compile_definitions(AP210 PRIVATE AP_NUM=210)

# ---------------------------------------------------------------------------
# APserver — shared-variable hub (no APmain / Svar_DB client needed)
# ---------------------------------------------------------------------------
add_executable(APserver
    APserver.cc
    Svar_DB_server.cc
    ../Svar_record.cc
)
target_include_directories(APserver
    PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/.."  # src/
        "${CMAKE_BINARY_DIR}"
        "${CMAKE_SOURCE_DIR}"
)
target_compile_features(APserver PRIVATE cxx_std_17)
target_compile_options(APserver PRIVATE -Wall -Wno-strict-aliasing)

# ---------------------------------------------------------------------------
# Installation: same bin dir as apl
# ---------------------------------------------------------------------------
install(TARGETS AP100 AP210 APserver
        RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}")
