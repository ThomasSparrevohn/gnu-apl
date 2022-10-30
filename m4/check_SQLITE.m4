
# {{ check if SQLite3 is wanted and installed...

apl_SQLITE3=no   # assume neither wanted nor installed

# no point to proceed without sqlite3.h

m4_include([m4/ax_lib_sqlite3.m4])   # define AX_LIB_SQLITE3()
AX_LIB_SQLITE3([])                   # call AX_LIB_SQLITE3()
    #
    # ./configure --with-sqlite3="no"   →    $withval: "no"
    # ./configure --without-sqlite3     →    $withval: "no"
    # ./configure                       →    $withval: "yes"
    # ./configure --with-sqlite3        →    $withval: "yes"
    # ./configure --with-sqlite3=yes    →    $withval: "yes"
    # ./configure --with-sqlite3=path   →    $withval: "path"
    #
if apl_NNO($with_sqlite3); then   # the user allows sqlite3 (if available)

   apl_SQLITE3=$found_sqlite   # set to yes/no in m4/ax_lib_sqlite3.m4
   if apl_YES($sqlite_given); then
      AC_DEFINE_UNQUOTED(cfg_USER_WANTS_SQLITE3, 1,
                         [./configure with --with-sqlite3])
   fi
fi

echo "apl_SQLITE3: $apl_SQLITE3"
# export apl_SQLITE3 to config.h
if apl_YES($apl_SQLITE3); then
   AC_DEFINE_UNQUOTED([apl_SQLITE3], [1], [SQLite code compiles])
fi


# export apl_SQLITE3 to Makefile.am
AM_CONDITIONAL(apl_SQLITE3, [apl_YES($apl_SQLITE3)])

# }} end of SQLITE check.

