
# check if PostgreSQL is wanted and installed
m4_include([m4/ax_lib_postgresql.m4])         AX_LIB_POSTGRESQL([])
if test "x$want1_postgresql" = "xyes"; then
   AC_DEFINE_UNQUOTED([REALLY_WANT_PostgreSQL], [1],
                      [./configure with --with-postgresql])
fi

# check if PostgreSQL is usable (if present)
if test "x$found_postgresql" = "xyes" ; then
    AC_MSG_CHECKING([for PostgreSQL usability])
    saved_CPPFLAGS="$CPPFLAGS"
    CPPFLAGS="$CPPFLAGS $POSTGRESQL_CFLAGS"
    AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[@%:@include <libpq-fe.h>]],
                      [[PGconn *db = PQconnectdbParams( 0, 0, 1 );]])],
                      [USABLE_PostgreSQL=yes],
                      [USABLE_PostgreSQL=no])

    CPPFLAGS="$saved_CPPFLAGS"
    AC_MSG_RESULT([$USABLE_PostgreSQL])
    if test "x$USABLE_PostgreSQL" = "xyes"; then
        AC_DEFINE_UNQUOTED([USABLE_PostgreSQL], [1], [PostgreSQL code compiles])
    fi
fi

