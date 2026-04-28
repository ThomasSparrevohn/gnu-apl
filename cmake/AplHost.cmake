# cmake/AplHost.cmake
# Host OS detection and platform-specific dependency search hints.

set(APL_HOST_LINUX FALSE)
set(APL_HOST_MACOS FALSE)
set(APL_HOST_FREEBSD FALSE)
set(APL_HOST_BSD FALSE)

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(APL_HOST_LINUX TRUE)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(APL_HOST_MACOS TRUE)
elseif(CMAKE_SYSTEM_NAME STREQUAL "FreeBSD")
    set(APL_HOST_FREEBSD TRUE)
    set(APL_HOST_BSD TRUE)
elseif(CMAKE_SYSTEM_NAME MATCHES "BSD$")
    set(APL_HOST_BSD TRUE)
endif()

set(APL_PLATFORM_PREFIX_HINTS "")

if(APL_HOST_MACOS)
    find_program(APL_BREW_EXECUTABLE brew)

    if(APL_BREW_EXECUTABLE)
        execute_process(
            COMMAND "${APL_BREW_EXECUTABLE}" --prefix
            OUTPUT_VARIABLE APL_HOMEBREW_PREFIX
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_QUIET
            RESULT_VARIABLE APL_HOMEBREW_PREFIX_RESULT
        )

        if(APL_HOMEBREW_PREFIX_RESULT EQUAL 0
           AND APL_HOMEBREW_PREFIX
           AND IS_DIRECTORY "${APL_HOMEBREW_PREFIX}")
            list(APPEND APL_PLATFORM_PREFIX_HINTS "${APL_HOMEBREW_PREFIX}")
        endif()

        foreach(_formula
                gsl
                fftw
                libpng
                pcre2
                sqlite
                postgresql
                gtk+3
                pkg-config)
            execute_process(
                COMMAND "${APL_BREW_EXECUTABLE}" --prefix "${_formula}"
                OUTPUT_VARIABLE _brew_formula_prefix
                OUTPUT_STRIP_TRAILING_WHITESPACE
                ERROR_QUIET
                RESULT_VARIABLE _brew_formula_result
            )

            if(_brew_formula_result EQUAL 0
               AND _brew_formula_prefix
               AND IS_DIRECTORY "${_brew_formula_prefix}")
                list(APPEND APL_PLATFORM_PREFIX_HINTS "${_brew_formula_prefix}")
            endif()
        endforeach()
    endif()

    if(IS_DIRECTORY "/opt/X11")
        list(APPEND APL_PLATFORM_PREFIX_HINTS "/opt/X11")
    endif()

elseif(APL_HOST_FREEBSD)
    list(APPEND APL_PLATFORM_PREFIX_HINTS
        /usr/local
    )

elseif(APL_HOST_LINUX)
    list(APPEND APL_PLATFORM_PREFIX_HINTS
        /usr
        /usr/local
    )
endif()

foreach(_prefix IN LISTS APL_PLATFORM_PREFIX_HINTS)
    if(IS_DIRECTORY "${_prefix}")
        list(APPEND CMAKE_PREFIX_PATH "${_prefix}")
    endif()
endforeach()

list(REMOVE_DUPLICATES APL_PLATFORM_PREFIX_HINTS)
list(REMOVE_DUPLICATES CMAKE_PREFIX_PATH)

message(STATUS "APL: host OS: ${CMAKE_SYSTEM_NAME}")
message(STATUS "APL: dependency prefix hints: ${APL_PLATFORM_PREFIX_HINTS}")
