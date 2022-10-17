
################################# GTK3 check #################################
#
AC_ARG_WITH([gtk3],
    AS_HELP_STRING([--with-gtk3],
    [enable ⎕GTK (interface to GTK+ version 3; needs libgtk-3 and more)]))

HAVE_gtk3=no
AC_SUBST(GTK_LDFLAGS)
AC_SUBST(GTK_CFLAGS)
GTK_LDFLAGS=
GTK_CFLAGS=
AC_MSG_CHECKING([whether support for ⎕GTK (needs GTK version 3) is desired])
if test "x$with_gtk3" = "xno"       # user has explicitly disabled GTK
then
    AC_MSG_RESULT([no - (user has explicitly disabled ⎕GTK)])
else
    # user wants ⎕GTK)
    AC_MSG_RESULT([yes])

    AC_PATH_PROG(PKG_CONFIG, pkg-config, no)  # locate pkg-config
    if test x$PKG_CONFIG != xno
    then
        AC_MSG_CHECKING([if package gtk+-3.0 is installed])
        if $PKG_CONFIG --exists gtk+-3.0
        then
            AC_MSG_RESULT([yes])
            GTK_CFLAGS=`$PKG_CONFIG --cflags gtk+-3.0`
            GTK_LDFLAGS=`$PKG_CONFIG --libs gtk+-3.0`
            HAVE_gtk3=yes
        else
            AC_MSG_RESULT([no])
            HAVE_gtk3=no
        fi
    else
        AC_MSG_RESULT([no (cannot use GTK without pkg-config)])
        HAVE_gtk3=no
    fi
fi

# export HAVE_GTK3 to Makefile
AM_CONDITIONAL(HAVE_GTK3, test "x$HAVE_gtk3" = xyes)

# export HAVE_GTK3 to config.h
if test "x$HAVE_gtk3" = xyes; then
   AC_DEFINE_UNQUOTED(HAVE_GTK3, [1], [GTK+ version 3 installed])
fi

