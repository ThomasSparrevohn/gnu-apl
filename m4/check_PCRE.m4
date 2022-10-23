
# check if libpcre is installed
m4_include([m4/ax_path_lib_pcre.m4])
   AX_PATH_LIB_PCRE([])         # sets: ac_cv_lib_pcre2_32_pcre2_compile_32
   apl_PCRE=$ac_cv_lib_pcre2_32_pcre2_compile_32

# export apl_PCRE to Makefile.am
AM_CONDITIONAL(apl_PCRE, apl_EQ($apl_PCRE, yes))

