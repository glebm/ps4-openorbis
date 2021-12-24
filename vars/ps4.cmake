cmake_minimum_required(VERSION 3.0)

###################################################################

if (NOT DEFINED ENV{OPENORBIS})
    set(OPENORBIS /opt/pacbrew/ps4/openorbis)
else ()
    set(OPENORBIS $ENV{OPENORBIS})
endif ()

if (NOT DEFINED ENV{OO_PS4_TOOLCHAIN})
    set(OO_PS4_TOOLCHAIN /opt/pacbrew/ps4/openorbis)
else ()
    set(OO_PS4_TOOLCHAIN $ENV{OO_PS4_TOOLCHAIN})
endif ()

list(APPEND CMAKE_MODULE_PATH "${OPENORBIS}/cmake")

set(PS4 TRUE)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR "x86_64")
set(CMAKE_CROSSCOMPILING 1)

set(CMAKE_ASM_COMPILER ${OPENORBIS}/bin/clang CACHE PATH "")
set(CMAKE_C_COMPILER ${OPENORBIS}/bin/clang CACHE PATH "")
set(CMAKE_CXX_COMPILER ${OPENORBIS}/bin/clang++ CACHE PATH "")
set(CMAKE_LINKER ${OPENORBIS}/bin/ld.lld CACHE PATH "")
set(CMAKE_AR ${OPENORBIS}/bin/llvm-ar CACHE PATH "")
set(CMAKE_RANLIB ${OPENORBIS}/bin/llvm-ranlib CACHE PATH "")
set(CMAKE_STRIP ${OPENORBIS}/bin/llvm-strip CACHE PATH "")

set(CMAKE_LIBRARY_ARCHITECTURE x86_64 CACHE INTERNAL "abi")

set(CMAKE_FIND_ROOT_PATH ${OPENORBIS} ${OPENORBIS}/usr)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(BUILD_SHARED_LIBS OFF CACHE INTERNAL "Shared libs not available")

###################################################################

set(PS4_ARCH_SETTINGS "--target=x86_64-pc-freebsd12-elf")
set(PS4_COMMON_INCLUDES "-isysroot ${OPENORBIS} -isystem ${OPENORBIS}/include -I${OPENORBIS}/usr/include")
set(PS4_COMMON_FLAGS "${PS4_ARCH_SETTINGS} -D__PS4__ -D__OPENORBIS__ -fPIC -funwind-tables ${PS4_COMMON_INCLUDES}")
set(PS4_COMMON_LIBS "-L${OPENORBIS}/lib -L${OPENORBIS}/usr/lib ${OPENORBIS}/lib/crt1.o")

set(CMAKE_C_FLAGS_INIT "${PS4_COMMON_FLAGS}")
set(CMAKE_CXX_FLAGS_INIT "${PS4_COMMON_FLAGS} -I${OPENORBIS}/include/c++/v1")
set(CMAKE_ASM_FLAGS_INIT "${PS4_COMMON_FLAGS}")

set(PS4_LINKER_FLAGS "-m elf_x86_64 -pie --script ${OPENORBIS}/link.x --eh-frame-hdr")
set(CMAKE_EXE_LINKER_FLAGS_INIT "${PS4_ARCH_SETTINGS} ${PS4_COMMON_LIBS} ${PS4_LINKER_FLAGS}")

# Start find_package in config mode
set(CMAKE_FIND_PACKAGE_PREFER_CONFIG TRUE)

# Set pkg-config for the same
find_program(PKG_CONFIG_EXECUTABLE NAMES openorbis-pkg-config HINTS "${OPENORBIS}/usr/bin")
if (NOT PKG_CONFIG_EXECUTABLE)
    message(WARNING "Could not find openorbis-pkg-config: try installing ps4-openorbis-pkg-config")
endif ()
