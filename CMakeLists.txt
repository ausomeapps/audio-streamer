cmake_minimum_required(VERSION 3.1)

project(audio_streamer)

set(CPP_SRC_DIR src)
set(OBJ_C_DIR platform/objc)
set(GENERATED_SRC_DIR generated-src)
set(GENERATED_SRC_CPP_DIR ${GENERATED_SRC_DIR}/cpp)
set(GENERATED_SRC_JNI_DIR ${GENERATED_SRC_DIR}/jni)
set(GENERATED_SRC_OBJC_DIR ${GENERATED_SRC_DIR}/objc)

# C++ sources
file(GLOB_RECURSE CPP_SRC
    ${CPP_SRC_DIR}/*.cpp
    ${CPP_SRC_DIR}/*.hpp
    ${CPP_SRC_DIR}/*.h
    ${GENERATED_SRC_CPP_DIR}/*.cpp
    ${GENERATED_SRC_CPP_DIR}/*.hpp
    ${GENERATED_SRC_CPP_DIR}/*.h
)
add_library(audio_streamer STATIC ${CPP_SRC})
source_group("cpp" FILES ${CPP_SRC})

add_subdirectory(${CMAKE_SOURCE_DIR}/../djinni)

if(APPLE)
    find_library(AVFOUNDATION AVFoundation)
    find_library(COREMEDIA CoreMedia)
    target_link_libraries(audio_streamer ${AVFOUNDATION} ${COREMEDIA})
    file(GLOB_RECURSE OBJ_C_SRC
        ${OBJ_C_DIR}/*.h
        ${OBJ_C_DIR}/*.mm
        ${OBJ_C_DIR}/*.m
        ${GENERATED_SRC_OBJC_DIR}/*.h
        ${GENERATED_SRC_OBJC_DIR}/*.mm
        ${GENERATED_SRC_OBJC_DIR}/*.m
    )
    target_sources(audio_streamer PUBLIC ${OBJ_C_SRC})
    source_group("objc" FILES ${OBJ_C_SRC})
    include_directories(
        include
        ${GENERATED_SRC_CPP_DIR}
        ${GENERATED_SRC_OBJC_DIR}
        ${OBJ_C_DIR}
        ${AVFOUNDATION}
        ${COREMEDIA}
        ${CMAKE_SOURCE_DIR}/../djinni/support-lib
        ${CMAKE_SOURCE_DIR}/../djinni/support-lib/objc
    )
endif(APPLE)
