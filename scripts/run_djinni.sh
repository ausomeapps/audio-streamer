#!/bin/bash

base_dir=$(cd "`dirname "0"`" && pwd)/../
in="$base_dir/djinni/audio-streamer.djinni"
cpp_out="$base_dir/generated-src/cpp"
jni_out="$base_dir/generated-src/jni"
objc_out="$base_dir/generated-src/objc"
java_out="$base_dir/generated-src/java/com/mobilecpp/streamer"
java_package="com.mobilecpp.streamer"
objc_prefix="MCP"
$base_dir/deps/djinni/src/run \
   --java-out $java_out \
   --java-package $java_package \
   --ident-java-field mFooBar \
    \
    --cpp-out $cpp_out \
    --cpp-namespace mobilecpp \
    --ident-cpp-enum-type foo_bar \
    \
    --jni-out $jni_out \
    --ident-jni-class NativeFooBar \
    --ident-jni-file NativeFooBar \
    \
	--objc-out $objc_out \
    --objcpp-out $objc_out \
    --objc-type-prefix $objc_prefix \
    \
    --idl "$in"
