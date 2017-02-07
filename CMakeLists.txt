cmake_minimum_required(VERSION 3.1)

project(AudioStreamer)

#
# Setup the directories
#
set(CPP_INCLUDE_DIR include)
set(CPP_SRC_DIR src)
set(OBJ_C_DIR platform/objc)
set(DJINNI_DIR deps/djinni)
set(DJINNI_SUPPORT_DIR ${DJINNI_DIR}/support-lib)
set(DJINNI_SUPPORT_JNI_DIR ${DJINNI_SUPPORT_DIR}/jni)
set(DJINNI_SUPPORT_OBJ_C_DIR ${DJINNI_SUPPORT_DIR}/objc)
set(GENERATED_SRC_DIR generated-src)
set(GENERATED_SRC_CPP_DIR ${GENERATED_SRC_DIR}/cpp)
set(GENERATED_SRC_JNI_DIR ${GENERATED_SRC_DIR}/jni)
set(GENERATED_SRC_OBJC_DIR ${GENERATED_SRC_DIR}/objc)
set(INCLUDE_DIRS
    ${CPP_INCLUDE_DIR}
    ${GENERATED_SRC_CPP_DIR}
    ${DJINNI_SUPPORT_DIR}
)
set(SRC_FILES "")

# C++ sources
file(GLOB_RECURSE CPP_HEADERS
    ${CPP_INCLUDE_DIR}/*.hpp
    ${CPP_INCLUDE_DIR}/*.h
    ${CPP_SRC_DIR}/*.hpp
    ${CPP_SRC_DIR}/*.h
)
file(GLOB_RECURSE CPP_SRC
    ${CPP_SRC_DIR}/*.cpp
)
file(GLOB_RECURSE CPP_GENERATED_HEADERS
    ${GENERATED_SRC_CPP_DIR}/*.hpp
    ${GENERATED_SRC_CPP_DIR}/*.h
)
file(GLOB_RECURSE CPP_GENERATED_SRC
    ${GENERATED_SRC_CPP_DIR}/*.cpp
)

# Append C++ sources to lib sources
list(APPEND SRC_FILES
    ${CPP_SRC}
    ${CPP_GENERATED_SRC}
)

# Create source groups for IDEs
source_group("include\\cpp" FILES ${CPP_HEADERS})
source_group("src\\cpp" FILES ${CPP_SRC})
source_group("generated-src\\cpp" FILES ${CPP_GENERATED_SRC})

if(APPLE)
    file(GLOB_RECURSE OBJ_C_HEADERS
        ${OBJ_C_DIR}/*.h
    )
    file(GLOB_RECURSE OBJ_C_SRC
        ${OBJ_C_DIR}/*.mm
        ${OBJ_C_DIR}/*.m
    )
    file(GLOB_RECURSE OBJ_C_GENERATED_HEADERS
        ${GENERATED_SRC_OBJC_DIR}/*.h
    )
    file(GLOB_RECURSE OBJ_C_GENERATED_SRC
        ${GENERATED_SRC_OBJC_DIR}/*.mm
        ${GENERATED_SRC_OBJC_DIR}/*.m
    )
    list(APPEND SRC_FILES
        ${OBJ_C_SRC}
        ${OBJ_C_GENERATED_SRC}
    )
    source_group("src\\objc" FILES ${OBJ_C_SRC})
    source_group("generated-src\\objc" FILES ${OBJ_C_GENERATED_SRC})
    list(APPEND INCLUDE_DIRS
        ${GENERATED_SRC_OBJC_DIR}
        ${OBJ_C_DIR}
        ${DJINNI_SUPPORT_OBJ_C_DIR}
    )
endif(APPLE)

if (ANDROID)
    file(GLOB_RECURSE JNI_GENERATED_HEADERS
        ${GENERATED_SRC_JNI_DIR}/*.h
        ${GENERATED_SRC_JNI_DIR}/*.hpp
    )
    file(GLOB_RECURSE JNI_GENERATED_SRC
        ${GENERATED_SRC_JNI_DIR}/*.cpp
    )
    list(APPEND SRC_FILES ${JNI_GENERATED_SRC})
    list(APPEND INCLUDE_DIRS ${DJINNI_SUPPORT_JNI_DIR} ${GENERATED_SRC_JNI_DIR})
endif(ANDROID)

# Add AudioStreamer library
add_library(AudioStreamer SHARED ${SRC_FILES})

# Link against djinni
add_subdirectory(${DJINNI_DIR})
target_link_libraries(AudioStreamer djinni)

# Add included directories
include_directories(${INCLUDE_DIRS})

# Do extra stuff for apple framework
if (APPLE)
    set(FRAMEWORK_HEADERS
        ${CPP_HEADERS}
        ${CPP_GENERATED_HEADERS}
        ${OBJ_C_HEADERS}
        ${OBJ_C_GENERATED_HEADERS}
    )
    message("FRAMEWORK HEADERS: " ${FRAMEWORK_HEADERS})
    target_link_libraries(AudioStreamer "-framework AVFoundation")
    set_target_properties(AudioStreamer PROPERTIES
        CXX_STANDARD 11
		CXX_STANDARD_REQUIRED true
		CXX_EXTENSIONS false
        FRAMEWORK TRUE
        PUBLIC_HEADER "${FRAMEWORK_HEADERS}"
        XCODE_ATTRIBUTE_ONLY_ACTIVE_ARCH NO
        MACOSX_FRAMEWORK_BUNDLE_VERSION "1.0.0"
        MACOSX_FRAMEWORK_IDENTIFIER "com.mobilecpp.audiostreamer"
    )
    target_compile_options(AudioStreamer PUBLIC "-fobjc-arc")
endif(APPLE)
