cmake_minimum_required(VERSION 3.10)
project(derplanner)

if (NOT DERPLANNER_ROOT) 
set(DERPLANNER_ROOT "ext/derplanner")
endif()

if (NOT DERPLANNER_SRC_DIR) 
set(DERPLANNER_SRC_DIR "${DERPLANNER_ROOT}/source/runtime")
endif()

if (NOT DERPLANNER_INC_DIR) 
set(DERPLANNER_INC_DIR "${DERPLANNER_ROOT}/include")
endif()

if (NOT HL_INCLUDE_DIR) 
    set(HL_INCLUDE_DIR "/usr/local/include")
endif()

if (NOT HL_LIB_DIR) 
    set(HL_LIB_DIR "/usr/local/lib")
endif()

if (NOT COMMON_LIB_DIR) 
    set(COMMON_LIB_DIR "/usr/local/lib")
endif()

if (NOT HDLL_DESTINATION) 
    set(HDLL_DESTINATION "/usr/local/lib")
endif()

add_library(derplanner.hdll SHARED
#Input C++ files go here
${DERPLANNER_SRC_DIR}/database.cpp
${DERPLANNER_SRC_DIR}/memory.cpp
${DERPLANNER_SRC_DIR}/planning.cpp
src/derplanner.cpp
src/hl-idl-helpers.cpp
)

set_target_properties(derplanner.hdll
PROPERTIES
PREFIX ""
OUTPUT_NAME derplanner
SUFFIX .hdll
)

cmake_policy(SET CMP0015 NEW)

target_include_directories(derplanner.hdll
PRIVATE
${DERPLANNER_INC_DIR}
${HL_INCLUDE_DIR}
)

link_directories(derplanner.hdll
${HL_LIB_DIR}
)

if (UNIX)
find_library(LIBHL NAMES hl HINTS ${HL_LIB_DIR} )
else()
find_library(LIBHL NAMES libhl HINTS ${HL_LIB_DIR} )
endif()
             
             
target_link_libraries(derplanner.hdll ${LIBHL} ${LIBMBEDTLS} ${LIBMBEDCRYPTO} ${LIBMBEDX509} ${LIBSODIUM})

if (UNIX)
    # Some special flags are needed for GNU GCC compiler
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -fPIC  -O3  -fpermissive")
    #not sure why the ${HL_LIB_DIR} is necessary given the above.
    SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -shared  ")
endif (UNIX)

install(TARGETS derplanner.hdll DESTINATION ${HDLL_DESTINATION})
