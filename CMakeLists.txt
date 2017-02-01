cmake_minimum_required(VERSION 3.1)

project(audio_streamer)

set(CPP_INCLUDE_DIR include)
set(CPP_SRC_DIR src)
set(OBJ_C_DIR platform/objc)
set(GENERATED_SRC_DIR generated-src)
set(GENERATED_SRC_CPP_DIR ${GENERATED_SRC_DIR}/cpp)
set(GENERATED_SRC_JNI_DIR ${GENERATED_SRC_DIR}/jni)
set(GENERATED_SRC_OBJC_DIR ${GENERATED_SRC_DIR}/objc)

# C++ sources
file(GLOB_RECURSE CPP_SRC
    ${CPP_INCLUDE_DIR}/*.hpp
    ${CPP_INCLUDE_DIR}/*.h
    ${CPP_SRC_DIR}/*.cpp
    ${CPP_SRC_DIR}/*.hpp
    ${CPP_SRC_DIR}/*.h
    ${GENERATED_SRC_CPP_DIR}/*.cpp
    ${GENERATED_SRC_CPP_DIR}/*.hpp
    ${GENERATED_SRC_CPP_DIR}/*.h
)
add_library(audio_streamer STATIC ${CPP_SRC})
source_group("cpp" FILES ${CPP_SRC})

add_subdirectory(deps/djinni)
target_link_libraries(audio_streamer djinni)

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
        ${CPP_INCLUDE_DIR}
        ${GENERATED_SRC_CPP_DIR}
        ${GENERATED_SRC_OBJC_DIR}
        ${OBJ_C_DIR}
        ${AVFOUNDATION}
        ${COREMEDIA}
        deps/djinni/support-lib
        deps/djinni/support-lib/objc
    )
    target_compile_options(audio_streamer PUBLIC "-fobjc-arc")
endif(APPLE)
