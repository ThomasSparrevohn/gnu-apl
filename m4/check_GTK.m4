
################################# GTK3 check #################################
#
AC_ARG_WITH([gtk3],
    AS_HELP_STRING([--with-gtk3],
    [enable ⎕GTK (interface to GTK+ version 3; needs libgtk-3 and more)]))

apl_GTK3=no
AC_SUBST(GTK_LDFLAGS)
AC_SUBST(GTK_CFLAGS)
GTK_LDFLAGS=
GTK_CFLAGS=
AC_MSG_CHECKING([whether support for ⎕GTK (needs GTK version 3) is desired])
if apl_EQ($with_gtk3, no)       # user has explicitly disabled GTK
then
    AC_MSG_RESULT([no - (user has explicitly disabled ⎕GTK)])
else
    # user wants ⎕GTK)
    AC_MSG_RESULT([yes])

    AC_PATH_PROG(PKG_CONFIG, pkg-config, no)  # locate pkg-config
    if apl_NEQ($PKG_CONFIG, no); then        # pkg-config present
        AC_MSG_CHECKING([if package gtk+-3.0 is installed])
        if $PKG_CONFIG --exists gtk+-3.0         # package gtk+-3.0  exists
        then
            AC_MSG_RESULT([yes])
            GTK_CFLAGS=`$PKG_CONFIG --cflags gtk+-3.0`
            GTK_LDFLAGS=`$PKG_CONFIG --libs gtk+-3.0`
            apl_GTK3=yes
        else                                     # package gtk+-3.0 missing
            AC_MSG_RESULT([no])
            apl_GTK3=no
        fi
    else                                      # pkg-config missing
        AC_MSG_RESULT([no (cannot use GTK without pkg-config)])
        apl_GTK3=no
    fi
fi

# export apl_GTK3 to Makefile
AM_CONDITIONAL(apl_GTK3, apl_EQ($apl_GTK3, yes))

# export apl_GTK3 to config.h
if apl_EQ($apl_GTK3, yes); then
   AC_DEFINE_UNQUOTED(apl_GTK3, [1], [GTK+ version 3 installed])
fi

