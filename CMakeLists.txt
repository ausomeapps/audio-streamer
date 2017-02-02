cmake_minimum_required(VERSION 3.1)

project(AudioStreamer)

set(CPP_INCLUDE_DIR include)
set(CPP_SRC_DIR src)
set(OBJ_C_DIR platform/objc)
set(GENERATED_SRC_DIR generated-src)
set(GENERATED_SRC_CPP_DIR ${GENERATED_SRC_DIR}/cpp)
set(GENERATED_SRC_JNI_DIR ${GENERATED_SRC_DIR}/jni)
set(GENERATED_SRC_OBJC_DIR ${GENERATED_SRC_DIR}/objc)

# C++ sources
file(GLOB_RECURSE CPP_INCLUDES
    ${CPP_INCLUDE_DIR}/*.hpp
    ${CPP_INCLUDE_DIR}/*.h
)
file(GLOB_RECURSE CPP_SRC
    ${CPP_SRC_DIR}/*.cpp
    ${CPP_SRC_DIR}/*.hpp
    ${CPP_SRC_DIR}/*.h
)
file(GLOB_RECURSE CPP_GENERATED_SRC
    ${GENERATED_SRC_CPP_DIR}/*.cpp
    ${GENERATED_SRC_CPP_DIR}/*.hpp
    ${GENERATED_SRC_CPP_DIR}/*.h
)

add_library(AudioStreamer SHARED
    ${CPP_INCLUDES}
    ${CPP_SRC}
    ${CPP_GENERATED_SRC}
)

source_group("include\\cpp" FILES ${CPP_INCLUDES})
source_group("src\\cpp" FILES ${CPP_SRC})
source_group("generated-src\\cpp" FILES ${CPP_GENERATED_SRC})

add_subdirectory(deps/djinni)
target_link_libraries(AudioStreamer djinni)

if(APPLE)
    find_library(AVFOUNDATION AVFoundation)
    target_link_libraries(AudioStreamer ${AVFOUNDATION})
    file(GLOB_RECURSE OBJ_C_SRC
        ${OBJ_C_DIR}/*.h
        ${OBJ_C_DIR}/*.mm
        ${OBJ_C_DIR}/*.m
    )
    file(GLOB_RECURSE OBJ_C_GENERATED_SRC
        ${GENERATED_SRC_OBJC_DIR}/*.h
        ${GENERATED_SRC_OBJC_DIR}/*.mm
        ${GENERATED_SRC_OBJC_DIR}/*.m
    )
    target_sources(AudioStreamer PUBLIC ${OBJ_C_SRC} ${OBJ_C_GENERATED_SRC})
    source_group("src\\objc" FILES ${OBJ_C_SRC})
    source_group("generated-src\\objc" FILES ${OBJ_C_GENERATED_SRC})
    include_directories(
        ${CPP_INCLUDE_DIR}
        ${GENERATED_SRC_CPP_DIR}
        ${GENERATED_SRC_OBJC_DIR}
        ${OBJ_C_DIR}
        ${AVFOUNDATION}
        deps/djinni/support-lib
        deps/djinni/support-lib/objc
    )
    target_compile_options(AudioStreamer PUBLIC "-fobjc-arc")
    set_target_properties(AudioStreamer PROPERTIES
      FRAMEWORK TRUE
    )
endif(APPLE)
