
AC_PATH_X()

if apl_YES($have_x); then
   AC_CHECK_HEADERS([xcb/xcb.h X11/Xlib.h X11/Xlib-xcb.h X11/Xutil.h],
                    [apl_X11=yes],
                    [apl_X11=no])

   # xcb/xproto.h needs xcb/xcb.h
   AC_CHECK_HEADER(xcb/xproto.h, [], [], [#include <xcb/xcb.h>])

   apl_have_opt_lib=yes   # assume all libs below are present
   apl_OPT_LIB([X11],     [XOpenDisplay],      [may affect: ⎕PLOT])
   apl_OPT_LIB([xcb],     [xcb_connect],       [may affect: ⎕PLOT])
   apl_OPT_LIB([X11-xcb], [XGetXCBConnection], [may affect: ⎕PLOT])
   apl_X11=$apl_have_opt_lib
else
   apl_X11=no
fi

