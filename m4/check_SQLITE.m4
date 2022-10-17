
# check if SQLite3 is wanted and installed

m4_include([m4/ax_lib_sqlite3.m4])    AX_LIB_SQLITE3([])

if test "x$WANT1_SQLITE3" = "xyes"; then
   AC_DEFINE_UNQUOTED([REALLY_WANT_SQLITE3], [1],
                      [./configure with --with-sqlite3])
fi

