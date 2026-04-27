# src/CMakeLists.txt
# Builds the GNU APL executable (and optionally libapl or the Python module).

# ---------------------------------------------------------------------------
# Common source list (mirrors common_SOURCES in src/Makefile.am)
# Only .cc files — headers/def/icc/m4 are omitted; they're picked up via
# dependencies when their corresponding .cc is compiled.
# ---------------------------------------------------------------------------
set(APL_COMMON_SOURCES
    Plot_ascii.cc
    Archive.cc
    Assert.cc
    Avec.cc
    Backtrace.cc
    Bif_F12_COMMA.cc
    Bif_F12_DOMINO.cc
    Bif_F12_INDEX_OF.cc
    Bif_F12_INTERVAL_INDEX.cc
    Bif_F12_FORMAT.cc
    Bif_F12_PARTITION_PICK.cc
    Bif_F12_SORT.cc
    Bif_F12_TAKE_DROP.cc
    Bif_OPER1_COMMUTE.cc
    Bif_OPER1_EACH.cc
    Bif_OPER2_POWER.cc
    Bif_OPER2_INNER.cc
    Bif_OPER2_OUTER.cc
    Bif_OPER2_RANK.cc
    Bif_OPER1_REDUCE.cc
    Bif_OPER1_SCAN.cc
    CDR.cc
    Cell.cc
    Cmd_KEYB.cc
    Cmd_LIB.cc
    Cmd_IN.cc
    Doxy.cc
    CharCell.cc
    Command.cc
    Common.cc
    ComplexCell.cc
    DerivedFunction.cc
    DiffOut.cc
    DynamicObject.cc
    Error.cc
    Executable.cc
    FloatCell.cc
    Function.cc
    Id.cc
    IndexExpr.cc
    IndexIterator.cc
    InputFile.cc
    IntCell.cc
    IO_Files.cc
    LApack.cc
    LibPaths.cc
    LineInput.cc
    Logging.cc
    LvalCell.cc
    Malloc_hooks.cc
    Nabla.cc
    Macro.cc
    Missing_Libraries.cc
    NamedObject.cc
    NativeFunction.cc
    NumericCell.cc
    Output.cc
    Parallel.cc
    Parser.cc
    Performance.cc
    PointerCell.cc
    Prefix.cc
    Plot_line_properties.cc
    Plot_data.cc
    Plot_window_properties.cc
    PrimitiveFunction.cc
    PrintBuffer.cc
    Polynomial.cc
    PythonPipe.cc
    QR_factorization_GSL.cc
    QuadFunction.cc
    ProcessorID.cc
    Quad_CC.cc
    Quad_CR.cc
    Quad_DLX.cc
    Quad_FFT.cc
    Quad_FIO.cc
    Quad_FX.cc
    Quad_GTK.cc
    Quad_JSON.cc
    Quad_MAP.cc
    Quad_MX.cc
    Quad_PLOT.cc
    Quad_PNG.cc
    Quad_RE.cc
    Quad_RL.cc
    Quad_RVAL.cc
    Quad_SQL.cc
    Quad_SVx.cc
    Quad_TF.cc
    Quad_WA.cc
    Quad_XML.cc
    RealCell.cc
    sbrk.cc
    Shape.cc
    ScalarFunction.cc
    Security.cc
    StateIndicator.cc
    Svar_DB.cc
    Svar_record.cc
    Symbol.cc
    SymbolTable.cc
    Sys.cc
    SystemVariable.cc
    TabExpansion.cc
    Thread_context.cc
    Token.cc
    Token_string.cc
    Tokenizer.cc
    UCS_string.cc
    UCS_string_vector.cc
    UserFunction.cc
    UserFunction_header.cc
    UserPreferences.cc
    UTF8_string.cc
    Value.cc
    ValueHistory.cc
    Workspace.cc
    static_Objects.cc
)

# ---------------------------------------------------------------------------
# Optional source additions
# ---------------------------------------------------------------------------

# PCRE2 support (⎕RE)
if(apl_PCRE)
    list(APPEND APL_COMMON_SOURCES Regexp.cc)
endif()

# SQLite3 support (⎕SQL)
if(apl_SQLITE3)
    list(APPEND APL_COMMON_SOURCES
        sql/SqliteArgListBuilder.cc
        sql/SqliteConnection.cc
        sql/SqliteResultValue.cc
        sql/SqliteProvider.cc
        sql/Connection.cc
    )
endif()

# PostgreSQL support (⎕SQL) – Connection.cc included only once
if(apl_POSTGRES)
    list(APPEND APL_COMMON_SOURCES
        sql/PostgresArgListBuilder.cc
        sql/PostgresConnection.cc
        sql/PostgresProvider.cc
    )
    if(NOT apl_SQLITE3)
        list(APPEND APL_COMMON_SOURCES sql/Connection.cc)
    endif()
endif()

# GTK3 plot sources
if(apl_GTK3)
    list(APPEND APL_COMMON_SOURCES Plot_gtk.cc)
endif()

# XCB plot sources
if(apl_XCB)
    list(APPEND APL_COMMON_SOURCES Plot_xcb.cc)
endif()

# ---------------------------------------------------------------------------
# Helper: set common include dirs and compile options on a target
# ---------------------------------------------------------------------------
function(apl_target_common_setup target_name)
    # The build directory contains our generated config.h.
    # The source directory is needed for src-relative headers.
    # The SQL subdirectory is on the path for sql/*.hh includes.
    target_include_directories(${target_name}
        PRIVATE
            "${CMAKE_BINARY_DIR}"          # generated config.h (found as "config.h")
            "${CMAKE_SOURCE_DIR}"          # top-level: for "../config.h" compat if needed
            "${CMAKE_CURRENT_SOURCE_DIR}"  # src/
            "${CMAKE_CURRENT_SOURCE_DIR}/sql"
    )

    # C++17
    target_compile_features(${target_name} PRIVATE cxx_std_17)

    # Base warnings (mirrors -Wall from Makefile.am)
    target_compile_options(${target_name} PRIVATE -Wall)

    # Optional: -Werror
    if(APL_WERROR_FLAG)
        target_compile_options(${target_name} PRIVATE "${APL_WERROR_FLAG}")
    endif()

    # Profiling / coverage
    if(APL_GPROF_FLAGS)
        target_compile_options(${target_name} PRIVATE "${APL_GPROF_FLAGS}")
        target_link_options(${target_name} PRIVATE "${APL_GPROF_FLAGS}")
    endif()
    if(APL_GCOV_FLAGS)
        target_compile_options(${target_name} PRIVATE "${APL_GCOV_FLAGS}")
        target_link_options(${target_name} PRIVATE "${APL_GCOV_FLAGS}")
    endif()

    # Required libraries
    target_link_libraries(${target_name} PRIVATE ${APL_REQUIRED_LIBS})

    # GTK3
    if(apl_GTK3 AND GTK3_FOUND)
        target_include_directories(${target_name} PRIVATE ${GTK3_INCLUDE_DIRS})
        target_compile_options(${target_name} PRIVATE ${GTK3_CFLAGS_OTHER})
        target_link_directories(${target_name} PRIVATE ${GTK3_LIBRARY_DIRS})
        target_link_libraries(${target_name} PRIVATE ${GTK3_LIBRARIES})
    endif()

    # PCRE2
    if(apl_PCRE)
        target_include_directories(${target_name} PRIVATE ${APL_PCRE2_INCLUDE_DIRS})
        if(DEFINED APL_PCRE2_LIBRARY_DIRS)
            target_link_directories(${target_name} PRIVATE ${APL_PCRE2_LIBRARY_DIRS})
        endif()
        target_link_libraries(${target_name} PRIVATE ${APL_PCRE2_LIBRARIES})
    endif()

    # SQLite3
    if(apl_SQLITE3)
        target_include_directories(${target_name} PRIVATE ${APL_SQLITE3_INCLUDE_DIRS})
        target_link_libraries(${target_name} PRIVATE ${APL_SQLITE3_LIBRARIES})
    endif()

    # PostgreSQL
    if(apl_POSTGRES)
        target_include_directories(${target_name} PRIVATE ${APL_POSTGRESQL_INCLUDE_DIRS})
        target_link_libraries(${target_name} PRIVATE ${APL_POSTGRESQL_LIBRARIES})
    endif()

    # FFT
    if(apl_FFT)
        if(DEFINED FFTW3_INCLUDE_DIRS)
            target_include_directories(${target_name} PRIVATE ${FFTW3_INCLUDE_DIRS})
        endif()
        if(DEFINED FFTW3_LIBRARY_DIRS)
            target_link_directories(${target_name} PRIVATE ${FFTW3_LIBRARY_DIRS})
        endif()
        target_link_libraries(${target_name} PRIVATE ${FFTW3_LIBRARIES})
    endif()

    # PNG
    if(apl_PNG AND PNG_FOUND)
        target_link_libraries(${target_name} PRIVATE PNG::PNG)
    endif()

    # GSL
    if(apl_GSL AND GSL_FOUND)
        target_link_libraries(${target_name} PRIVATE GSL::gsl GSL::gslcblas)
    endif()

    # X11/XCB
    if(apl_XCB)
        if(DEFINED APL_XCB_LIBRARIES)
            target_link_libraries(${target_name} PRIVATE ${APL_XCB_LIBRARIES})
        endif()
        if(DEFINED X11_INCLUDE_DIR AND X11_INCLUDE_DIR)
            target_include_directories(${target_name} PRIVATE "${X11_INCLUDE_DIR}")
        endif()
    endif()
endfunction()

# ---------------------------------------------------------------------------
# export-dynamic: handle platform portability
# ---------------------------------------------------------------------------
# Replace the broken target_link_options trick above with a proper check.
include(CheckLinkerFlag OPTIONAL RESULT_VARIABLE _clf_found)
if(_clf_found)
    check_linker_flag(CXX -rdynamic _ld_rdynamic)
else()
    set(_ld_rdynamic FALSE)
endif()
find_library(_libdl dl)
if(APPLE)
    set(APL_EXPORT_DYNAMIC_FLAGS "")   # macOS: -export_dynamic not needed
elseif(_ld_rdynamic)
    set(APL_EXPORT_DYNAMIC_FLAGS "-rdynamic")
else()
    set(APL_EXPORT_DYNAMIC_FLAGS "")
endif()

# ---------------------------------------------------------------------------
# Build target selection
# ---------------------------------------------------------------------------

if(APL_WITH_LIBAPL)
    # -----------------------------------------------------------------------
    # libapl shared library
    # -----------------------------------------------------------------------
    add_library(libapl SHARED
        ${APL_COMMON_SOURCES}
        libapl.h
        libapl.cc
    )
    set_target_properties(libapl PROPERTIES
        OUTPUT_NAME "apl"
        PREFIX "lib"
        VERSION "${PROJECT_VERSION}"
        SOVERSION "0"
    )
    apl_target_common_setup(libapl)
    if(APL_EXPORT_DYNAMIC_FLAGS)
        target_link_options(libapl PRIVATE "${APL_EXPORT_DYNAMIC_FLAGS}")
    endif()

    # Install libapl
    install(TARGETS libapl
            LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}/apl"
            ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}/apl")
    install(FILES libapl.h Error.def
            DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/apl")

elseif(APL_WITH_PYTHON)
    # -----------------------------------------------------------------------
    # Python extension module lib_gnu_apl.so
    # -----------------------------------------------------------------------
    find_package(Python3 QUIET COMPONENTS Development.Module Interpreter)
    if(NOT Python3_FOUND)
        find_package(Python3 REQUIRED COMPONENTS Development Interpreter)
    endif()

    add_library(lib_gnu_apl MODULE
        ${APL_COMMON_SOURCES}
        python_apl.cc
    )
    set_target_properties(lib_gnu_apl PROPERTIES
        PREFIX ""
        OUTPUT_NAME "lib_gnu_apl"
    )
    apl_target_common_setup(lib_gnu_apl)
    target_include_directories(lib_gnu_apl PRIVATE ${Python3_INCLUDE_DIRS})
    target_link_libraries(lib_gnu_apl PRIVATE ${Python3_LIBRARIES})
    target_compile_options(lib_gnu_apl PRIVATE
        -DNDEBUG
        -D_FORTIFY_SOURCE=2
        -fwrapv
        -fPIC
        -fstack-protector
    )
    if(APL_EXPORT_DYNAMIC_FLAGS)
        target_link_options(lib_gnu_apl PRIVATE "${APL_EXPORT_DYNAMIC_FLAGS}")
    endif()

    install(TARGETS lib_gnu_apl
            LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}/apl")

else()
    # -----------------------------------------------------------------------
    # Normal apl executable
    # -----------------------------------------------------------------------
    add_executable(${APL_EXECUTABLE_NAME}
        main.cc
        ${APL_COMMON_SOURCES}
    )
    apl_target_common_setup(${APL_EXECUTABLE_NAME})
    if(APL_EXPORT_DYNAMIC_FLAGS)
        target_link_options(${APL_EXECUTABLE_NAME} PRIVATE "${APL_EXPORT_DYNAMIC_FLAGS}")
    endif()

    install(TARGETS ${APL_EXECUTABLE_NAME}
            RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}")

    # CTest: run all testcases
    if(BUILD_TESTING)
        file(GLOB _testcases
             LIST_DIRECTORIES FALSE
             "${CMAKE_CURRENT_SOURCE_DIR}/testcases/*.tc")
        if(_testcases)
            add_test(
                NAME apl_testcases
                COMMAND ${APL_EXECUTABLE_NAME} --id 1010 -T ${_testcases}
                WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
            )
            set_tests_properties(apl_testcases PROPERTIES
                TIMEOUT 600
            )

            # strict variant: same invocation as the default test — both use
            # the default TM_EXIT_AFTER_LAST_FILE mode which is the only mode
            # that produces a clean exit code under CTest (non-TTY stdin).
            # --TM N (N>0) modes do not auto-exit after the last file when
            # stdin is a pipe, so they are not suitable for automated testing.
            add_test(
                NAME apl_testcases_strict
                COMMAND ${APL_EXECUTABLE_NAME} --id 1010 -T ${_testcases}
                WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
            )
            set_tests_properties(apl_testcases_strict PROPERTIES
                TIMEOUT 600
            )

            # AP-related tests
            file(GLOB _ap_testcases
                 LIST_DIRECTORIES FALSE
                 "${CMAKE_CURRENT_SOURCE_DIR}/testcases/AP*.tc")
            if(_ap_testcases)
                add_test(
                    NAME apl_testcases_AP
                    COMMAND ${APL_EXECUTABLE_NAME} --id 1010 -T ${_ap_testcases}
                    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
                )
            endif()
        endif()
    endif()

endif()

# ---------------------------------------------------------------------------
# Custom target: update-svar_signals
# Regenerates Svar_signals.hh from Svar_signals.def + tcp_signal.m4
# ---------------------------------------------------------------------------
find_program(M4_PROG m4)
if(M4_PROG)
    add_custom_target(update-svar_signals
        COMMAND ${M4_PROG} -D protocol=Svar_signals
                "${CMAKE_CURRENT_SOURCE_DIR}/tcp_signal.m4"
                > "${CMAKE_CURRENT_SOURCE_DIR}/Svar_signals.hh"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        COMMENT "Regenerating Svar_signals.hh"
        VERBATIM
    )
endif()
