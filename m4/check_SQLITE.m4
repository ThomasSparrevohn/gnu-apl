
# check if SQLite3 is wanted and installed

m4_include([m4/ax_lib_sqlite3.m4])
   AX_LIB_SQLITE3([])                   # sets: found_sqlite, WANT_SQLITE3
   apl_SQLITE3=$found_sqlite            # import into apl_ namespace

if apl_EQ($found_sqlite, yes) && apl_EQ($WANT_SQLITE3, yes); then
   AC_DEFINE_UNQUOTED([REALLY_WANT_SQLITE3], [1], [SQLite available and wanted])
fi

if apl_EQ($WANT_SQLITE3, yes); then
   AC_DEFINE_UNQUOTED([apl_SQLITE3], [1], [SQLite available])
    fi


# export apl_SQLITE3 to Makefile.am
AM_CONDITIONAL([apl_SQLITE3], [apl_EQ($apl_SQLITE3, yes)])

