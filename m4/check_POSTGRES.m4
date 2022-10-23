
# check if PostgreSQL is wanted and installed

apl_POSTGRES=no

# no point to proceed without libpq-fe.h
AC_CHECK_HEADER([libpq-fe.h],
[
    m4_include([m4/ax_lib_postgresql.m4])
       AX_LIB_POSTGRESQL([])        # sets: found_postgresql, want_postgresql
       apl_POSTGRES=$found_postgresql       # import into apl_ namespace

    if apl_EQ($found_postgresql, yes) && apl_EQ($want_postgresql, yes); then
       AC_DEFINE_UNQUOTED([REALLY_WANT_PostgreSQL], [1],
                          [./configure with --with-postgresql])
    fi

    # check if PostgreSQL is usable (if present)
    if apl_EQ($found_postgresql, yes) ; then
        AC_MSG_CHECKING([for PostgreSQL usability])
        saved_CPPFLAGS="$CPPFLAGS"
        CPPFLAGS="$CPPFLAGS $POSTGRESQL_CFLAGS"
        AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[@%:@include <libpq-fe.h>]],
                          [[PGconn *db = PQconnectdbParams( 0, 0, 1 );]])],
                          [apl_POSTGRES=yes],
                          [apl_POSTGRES=no])

        CPPFLAGS="$saved_CPPFLAGS"
        AC_MSG_RESULT([$apl_POSTGRES])
        if apl_EQ($apl_POSTGRES, yes); then
            AC_DEFINE_UNQUOTED([apl_POSTGRES], [1], [PostgreSQL code compiles])
        fi
    fi
])

# export apl_POSTGRES to Makefile.am
AM_CONDITIONAL([apl_POSTGRES], [apl_EQ($apl_POSTGRES, yes)])
