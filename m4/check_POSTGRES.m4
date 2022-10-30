
# {{ check if PostgreSQL is wanted and installed...

apl_POSTGRES=no   # assume neither wanted nor installed

m4_include([m4/ax_lib_postgresql.m4])   # define AX_LIB_POSTGRESQL()
AX_LIB_POSTGRESQL([])                   # call AX_LIB_POSTGRESQL()
    #
    # ./configure --with-postgresql="no"   →    $withval: "no"
    # ./configure --without-postgresql     →    $withval: "no"
    # ./configure                          →    $withval: "yes"
    # ./configure --with-postgresql        →    $withval: "yes"
    # ./configure --with-postgresql=yes    →    $withval: "yes"
    # ./configure --with-postgresql=path   →    $withval: "path"
    #
if apl_NNO($with_postgresql); then   # the user allows postgres (if available)

   apl_POSTGRES=$found_postgresql   # set to yes/no in ax_lib_postgresql.m4
   if apl_YES($postgresql_given); then
      AC_DEFINE_UNQUOTED(cfg_USER_WANTS_POSTGRES, 1,
                         [./configure with --with-postgresql])
   fi

    # if POSTGRES is present: check if it is usable
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
       if apl_YES($apl_POSTGRES); then
          AC_DEFINE_UNQUOTED([apl_POSTGRES], [1], [PostgreSQL code compiles])
        fi
    fi
fi

# export apl_POSTGRES to Makefile.am
AM_CONDITIONAL([apl_POSTGRES], [apl_EQ($apl_POSTGRES, yes)])

# }} end of PostgreSQL check.
