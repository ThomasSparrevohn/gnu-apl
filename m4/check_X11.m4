
# wrap multiple tests into a single dash function from which we may
# return prematurely (which m4 can't) if a sub-test fails...
#
dash_test_X11()
{ {
apl_X11=no

local have_x                   # 'yes', 'no', or 'disabled' by AC_PATH_X()
local x_includes x_libraries   # also set by AC_PATH_X(), normally empty

{ AC_PATH_X() } ; apl_NYES($have_x) && return

AC_CHECK_HEADERS([xcb/xcb.h X11/Xlib.h X11/Xlib-xcb.h X11/Xutil.h], , return)

# xcb/xproto.h needs xcb/xcb.h
AC_CHECK_HEADER(xcb/xproto.h, [], [return], [#include <xcb/xcb.h>])

apl_have_opt_lib=yes   # set to 'no' by apl_OPT_LIB() if missing
apl_OPT_LIB([X11],     [XOpenDisplay],      [may affect: ⎕PLOT])
apl_OPT_LIB([xcb],     [xcb_connect],       [may affect: ⎕PLOT])
apl_OPT_LIB([X11-xcb], [XGetXCBConnection], [may affect: ⎕PLOT])
apl_X11=$apl_have_opt_lib
} }
dash_test_X11   # perform the X11 tests

