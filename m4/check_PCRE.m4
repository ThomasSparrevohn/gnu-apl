
# check if libpcre is installed
m4_include([m4/ax_path_lib_pcre.m4])
   AX_PATH_LIB_PCRE([])
AM_CONDITIONAL(HAVE_LIBPCRE2_32,
               test "x$ac_cv_lib_pcre2_32_pcre2_compile_32" = xyes)

