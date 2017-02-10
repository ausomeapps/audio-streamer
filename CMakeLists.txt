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

#
# Setup the source and include directories for the AudioStreamer lib
#
set(INCLUDE_DIRS
    ${CPP_INCLUDE_DIR}
    ${GENERATED_SRC_CPP_DIR}
    ${DJINNI_SUPPORT_DIR}
)
set(SRC_FILES "")

#
# Recursively aggregate the C++ sources
#
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

#
# Append C++ sources to the library's source files
#
list(APPEND SRC_FILES
    ${CPP_HEADERS}
    ${CPP_SRC}
    ${CPP_GENERATED_HEADERS}
    ${CPP_GENERATED_SRC}
)

#
# Create source groups for IDEs (in particular, Xcode)
#
source_group("include\\cpp" FILES ${CPP_HEADERS})
source_group("src\\cpp" FILES ${CPP_SRC})
source_group("generated-src\\cpp" FILES ${CPP_GENERATED_SRC})

#
# If we're generating an Apple library we're going to be doing it as a
# framework. In addition to the C++ source and header files we're going to
# include the Objective-C source and header files as well.
#
if(APPLE)
    #
    # Recursively aggregate the Objective-C source and header files and
    # append them to the final include and source sets
    #
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
        ${OBJ_C_HEADERS}
        ${OBJ_C_SRC}
        ${OBJ_C_GENERATED_HEADERS}
        ${OBJ_C_GENERATED_SRC}
    )

    #
    # Create source groups for the Objective-C source and header files. We
    # will see these groups organized in Xcode's project view on the left.
    #
    source_group("src\\objc" FILES ${OBJ_C_SRC})
    source_group("generated-src\\objc" FILES ${OBJ_C_GENERATED_SRC})
    list(APPEND INCLUDE_DIRS
        ${GENERATED_SRC_OBJC_DIR}
        ${OBJ_C_DIR}
        ${DJINNI_SUPPORT_OBJ_C_DIR}
    )
endif(APPLE)

#
# For Android we're doing something a little different. We're going to be
# adding the java generated source files separated using Gradle, but use
# CMake to link against the JNI C++ source files.
#
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

#
# For both iOS and Android we're going to generate a shared library. On iOS
# this will be the resulting binary inside the AudioStreamer.framework. On
# Android this will create a libAudioStreamer.so shared library.
#
add_library(AudioStreamer SHARED ${SRC_FILES})

#
# We're going to link the AudioStreamer library against the djinni support
# library to make sure we're not missing any symbols.
#
add_subdirectory(${DJINNI_DIR})
target_link_libraries(AudioStreamer djinni)

#
# Now let's add the include directories list we've been appending to to CMake's
# list of include directories.
#
include_directories(${INCLUDE_DIRS})

#
# Now that we have a shared library generated we still need to do a little bit
# of extra work to make sure CMake generates a .framework instead of .dylib for
# our shared iOS library.
#
if (APPLE)
    #
    # Set the framework headers to include all the header references we've
    # previously defined so that they are included as public headers in the
    # .framework generated
    #
    set(FRAMEWORK_HEADERS
        ${CPP_HEADERS}
        ${CPP_GENERATED_HEADERS}
        ${OBJ_C_HEADERS}
        ${OBJ_C_GENERATED_HEADERS}
    )

    #
    # Link against the AVFoundation framework since we're using it to
    # implement the platform specific MCPAudioStreamerImpl class.
    #
    target_link_libraries(AudioStreamer "-framework AVFoundation")

    #
    # Finally we set the target properties to ensure we have a .framework
    # generated and it contains all our public headers, as well as the required
    # plist properties for Xcode to recognize the generated .framework as a
    # valid, standalone framework.
    #
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
