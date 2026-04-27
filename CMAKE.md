# CMake Build System for GNU APL

This document maps Autotools `./configure` invocations to their CMake equivalents.
The CMake build system is **additive** — Autotools files are not removed or modified.

---

## Quick Start

```sh
# Configure (out-of-tree, defaults)
cmake -S . -B cmake-build

# Build
cmake --build cmake-build -j$(nproc)

# Install
cmake --install cmake-build

# DESTDIR install
DESTDIR=/tmp/staging cmake --install cmake-build
```

---

## Configure Option Mapping

### Installation Directories

| Autotools                          | CMake                                             |
|------------------------------------|---------------------------------------------------|
| `--prefix=/usr`                    | `-DCMAKE_INSTALL_PREFIX=/usr`                     |
| `--bindir=/usr/local/bin`          | `-DCMAKE_INSTALL_BINDIR=bin` (relative to prefix) |
| `--libdir=/usr/local/lib64`        | `-DCMAKE_INSTALL_LIBDIR=lib64`                    |
| `--datarootdir=/usr/share`         | `-DCMAKE_INSTALL_DATAROOTDIR=share`               |
| `--sysconfdir=/etc`                | `-DCMAKE_INSTALL_SYSCONFDIR=etc`                  |
| `--docdir=/usr/share/doc/apl`      | `-DCMAKE_INSTALL_DOCDIR=share/doc/apl`            |
| `--mandir=/usr/share/man`          | `-DCMAKE_INSTALL_MANDIR=share/man`                |

> **Note:** `--exec-prefix` has no direct CMake equivalent; use individual directory
> variables or set `CMAKE_INSTALL_PREFIX` which applies uniformly.

### Compiler and Linker Variables

| Autotools env var          | CMake equivalent                                      |
|----------------------------|-------------------------------------------------------|
| `CC=gcc`                   | `-DCMAKE_C_COMPILER=gcc`                              |
| `CXX=clang++`              | `-DCMAKE_CXX_COMPILER=clang++`                        |
| `CFLAGS="-O2 -g"`          | `-DCMAKE_C_FLAGS="-O2 -g"`                            |
| `CXXFLAGS="-O2 -g"`        | `-DCMAKE_CXX_FLAGS="-O2 -g"`                          |
| `LDFLAGS="-L/opt/lib"`     | `-DCMAKE_EXE_LINKER_FLAGS="-L/opt/lib"`               |
| `CPPFLAGS="-I/opt/include"`| `-DCMAKE_CXX_FLAGS="-I/opt/include"` (or use HINTS in find_*) |

### Cross-Compilation

| Autotools          | CMake                                              |
|--------------------|----------------------------------------------------|
| `--host=arm-linux` | `-DCMAKE_TOOLCHAIN_FILE=/path/to/toolchain.cmake`  |
| `--build=x86_64`   | Handled by toolchain file                          |

### Program Name Transformations

| Autotools                      | CMake                                               |
|--------------------------------|-----------------------------------------------------|
| `--program-prefix=gnu-`        | `-DAPL_PROGRAM_PREFIX=gnu-`                         |
| `--program-suffix=-2.0`        | `-DAPL_PROGRAM_SUFFIX=-2.0`                         |

> Arbitrary `--program-transform-name` sed expressions are not implemented.

---

## Optional Libraries

| Autotools                              | CMake                                                         |
|----------------------------------------|---------------------------------------------------------------|
| `--with-sqlite3`                       | `-DAPL_WITH_SQLITE3=ON` (default ON)                         |
| `--with-sqlite3=/opt/sqlite`           | `-DAPL_WITH_SQLITE3=ON -DAPL_SQLITE3_ROOT=/opt/sqlite`       |
| `--without-sqlite3`                    | `-DAPL_WITH_SQLITE3=OFF`                                     |
| `--with-postgresql`                    | `-DAPL_WITH_POSTGRESQL=ON` (default ON)                      |
| `--without-postgresql`                 | `-DAPL_WITH_POSTGRESQL=OFF`                                  |
| `--with-postgresql=/path/pg_config`    | `-DAPL_POSTGRESQL_PG_CONFIG=/path/pg_config`                 |
| `--with-pcre` / PCRE                   | `-DAPL_WITH_PCRE=ON` (default ON)                            |
| `--with-gtk3`                          | `-DAPL_WITH_GTK3=ON` (default ON)                            |
| `--without-gtk3`                       | `-DAPL_WITH_GTK3=OFF`                                        |
| `--with-optional_libs=no`              | `-DAPL_WITH_OPTIONAL_LIBS=OFF`                               |

---

## Build Targets

| Autotools                 | CMake                              |
|---------------------------|------------------------------------|
| (default)                 | `-DAPL_WITH_LIBAPL=OFF` (default)  |
| `--with-libapl`           | `-DAPL_WITH_LIBAPL=ON`             |
| `--with-erlang`           | `-DAPL_WITH_ERLANG=ON`             |
| `--with-android`          | `-DAPL_WITH_ANDROID=ON`            |
| `--with-python`           | `-DAPL_WITH_PYTHON=ON`             |
| `--with-ctrld_del`        | `-DAPL_WITH_CTRLD_DEL=ON`         |

---

## Development / Tuning Variables

| Autotools env var                  | CMake option                          | Default |
|------------------------------------|---------------------------------------|---------|
| `CXX_WERROR=yes`                   | `-DAPL_CXX_WERROR=ON`                 | OFF     |
| `DEVELOP_WANTED=yes`               | `-DAPL_DEVELOP=ON`                    | OFF     |
| `MAX_RANK_WANTED=16`               | `-DAPL_MAX_RANK=16`                   | 8       |
| `ALT_MAP_WANTED=1`                 | `-DAPL_ALT_MAP=1`                     | 0       |
| `VALUE_CHECK_WANTED=yes`           | `-DAPL_VALUE_CHECK=ON`                | OFF     |
| `PERFORMANCE_COUNTERS_WANTED=yes`  | `-DAPL_PERFORMANCE_COUNTERS=ON`       | OFF     |
| `VALUE_HISTORY_WANTED=yes`         | `-DAPL_VALUE_HISTORY=ON`              | OFF     |
| `GPROF_WANTED=yes`                 | `-DAPL_GPROF=ON`                      | OFF     |
| `GCOV_WANTED=yes`                  | `-DAPL_GCOV=ON`                       | OFF     |
| `DYNAMIC_LOG_WANTED=yes`           | `-DAPL_DYNAMIC_LOG=ON`                | OFF     |
| `VF_TRACING_WANTED=yes`            | `-DAPL_VF_TRACING=ON`                 | OFF     |
| `ASSERT_LEVEL_WANTED=2`            | `-DAPL_ASSERT_LEVEL=2`                | 1       |
| `SECURITY_LEVEL_WANTED=1`          | `-DAPL_SECURITY_LEVEL=1`              | 0       |
| `CORE_COUNT_WANTED=4`              | `-DAPL_CORE_COUNT=4`                  | 0       |
| `APSERVER_TRANSPORT=UNIX`          | `-DAPL_APSERVER_TRANSPORT=UNIX`       | TCP     |
| `APSERVER_PORT=16366`              | `-DAPL_APSERVER_PORT=16366`           | 16366   |
| `APSERVER_PATH=/tmp/...`           | `-DAPL_APSERVER_PATH=/tmp/...`        | /tmp/GNU-APL/APserver |
| `SHORT_VALUE_LENGTH_WANTED=12`     | `-DAPL_SHORT_VALUE_LENGTH=12`         | 12      |
| `VISIBLE_MARKERS_WANTED=yes`       | `-DAPL_VISIBLE_MARKERS=ON`            | OFF     |
| `RATIONAL_NUMBERS_WANTED=yes`      | `-DAPL_RATIONAL_NUMBERS=ON`           | OFF     |

Legacy environment-variable names (e.g. `DEVELOP_WANTED`) are also accepted via
`-DDEVELOP_WANTED=yes` during the transition period.

---

## Common Invocation Examples

```sh
# Equivalent to: ./configure --prefix=/usr
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=/usr

# Equivalent to: ./configure CXX=clang++ CXXFLAGS="-O2 -g"
cmake -S . -B build \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_CXX_FLAGS="-O2 -g"

# Equivalent to: ./configure --with-sqlite3=/opt/homebrew/opt/sqlite --without-postgresql
cmake -S . -B build \
    -DAPL_WITH_SQLITE3=ON \
    -DAPL_SQLITE3_ROOT=/opt/homebrew/opt/sqlite \
    -DAPL_WITH_POSTGRESQL=OFF

# Equivalent to: ./configure --with-libapl
cmake -S . -B build -DAPL_WITH_LIBAPL=ON

# Equivalent to: ./configure --with-python
cmake -S . -B build -DAPL_WITH_PYTHON=ON

# Equivalent to: ./configure MAX_RANK_WANTED=16 ASSERT_LEVEL_WANTED=2
cmake -S . -B build -DAPL_MAX_RANK=16 -DAPL_ASSERT_LEVEL=2

# Minimal build (no optional libraries)
cmake -S . -B cmake-build-minimal -DAPL_WITH_OPTIONAL_LIBS=OFF
cmake --build cmake-build-minimal -j$(nproc)

# Cross-compilation with a toolchain file
cmake -S . -B build-cross \
    -DCMAKE_TOOLCHAIN_FILE=/path/to/arm-toolchain.cmake

# Install to DESTDIR (for packaging)
DESTDIR=/tmp/pkg cmake --install cmake-build
```

---

## Running Tests

```sh
# Build and run tests
cmake -S . -B build
cmake --build build -j
ctest --test-dir build --output-on-failure

# Run only the strict (stop-on-error) variant
ctest --test-dir build -R apl_testcases_strict --output-on-failure
```

---

## Files Added / Modified

| File                             | Purpose                                       |
|----------------------------------|-----------------------------------------------|
| `CMakeLists.txt`                 | Top-level CMake project                       |
| `src/CMakeLists.txt`             | Source build targets                          |
| `config.h.cmake.in`              | CMake config.h template                       |
| `cmake/AplOptions.cmake`         | All user-visible cache options                |
| `cmake/AplChecks.cmake`          | Platform and library detection                |
| `cmake/AplConfigSummary.cmake`   | Configuration summary message                 |
| `CMAKE.md`                       | This documentation file                       |

Autotools files (`configure.ac`, `Makefile.am`, `Makefile.in`, `config.h.in`,
`m4/`, etc.) are **not modified**.

---

## Intentionally Deferred / Not Implemented

- **RPM / DEB packaging** — not implemented (use Autotools `make RPM`/`make DEB`)
- **`make DOXY`** — available via `cmake --build <dir> --target DOXY` if Doxygen found
- **`make SVNUP` / `make SYNC`** — SVN-specific developer helpers, not applicable
- **`--program-transform-name`** — arbitrary sed transforms on executable name not implemented
- **Erlang `.erl` file generation** — handled by Autotools only
- **CPack** — not added (would need platform-specific packaging configuration)
- **Gtk/ subdirectory** — GTK sources compiled directly from src/ when GTK3 is enabled
- **APs/ subdirectory** — Attached Processor binaries not yet wired into CMake install
