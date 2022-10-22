
# check if SQLite3 is wanted and installed

m4_include([m4/ax_lib_sqlite3.m4])    AX_LIB_SQLITE3([])

if TEST_EQ($WANT1_SQLITE3, yes); then
   AC_DEFINE_UNQUOTED([REALLY_WANT_SQLITE3], [1],
                      [./configure with --with-sqlite3])
fi

# export found_sqlite to Makefile
AM_CONDITIONAL([SQLITE3], [TEST_EQ($found_sqlite, yes)])

