#!/bin/bash

base_dir=$(cd "`dirname "0"`" && pwd)/..
build_dir=$base_dir/build/macos
generated_src_dir=$base_dir/generated-src
lib_dir=$base_dir/lib/macos
polly_dir=$base_dir/deps/polly

if [ ! -d "$generated_src_dir" ]; then
  ./run_djinni.sh
fi

if [ ! -d "$build_dir" ]; then
  mkdir -p $build_dir
fi

if [ ! -d "$lib_dir" ]; then
  mkdir -p $lib_dir
fi

echo -e "----------------------------------------------------------------"
echo -e "-- Running CMake for AudioStreamer library (and dependencies) --"
echo -e "----------------------------------------------------------------\n"
cd $build_dir
cmake ../.. -GXcode -DCMAKE_TOOLCHAIN_FILE=$polly_dir/osx-10-12.cmake -DCMAKE_VERBOSE_MAKEFILE=ON;
echo -e ""

echo -e "--------------------------------------------------------"
echo -e "-- Compiling AudioStreamer library (and dependencies) --"
echo -e "--------------------------------------------------------\n"
xcodebuild -target AudioStreamer -configuration Release -arch x86_64 only_active_arch=no defines_module=yes -sdk "macosx"

echo -e "-------------------------------------------------"
echo -e "-- Moving AudioStreamer.framework macOS binary --"
echo -e "-------------------------------------------------\n"
cp -R Release/AudioStreamer.framework $lib_dir
echo -e "Success: \n" $lib_dir/AudioStreamer.framework "\n"

echo -e "---------------------------------------------------"
echo -e "-- Validating AudioStreamer.framework macOS binary --"
echo -e "---------------------------------------------------\n"
lipo -info $lib_dir/AudioStreamer.framework/AudioStreamer
echo -e ""

echo -e "----------------------------------------"
echo -e "-- Creating djinni.dylib macOS binary --"
echo -e "----------------------------------------n"
cd deps/djinni
cp -R Release/libdjinni.dylib $lib_dir
echo -e "Success: \n" $lib_dir/libdjinni.dylib "\n"

echo -e "------------------------------------"
echo -e "-- Validating djinni.dylib binary --"
echo -e "------------------------------------\n"
lipo -info $lib_dir/libdjinni.dylib
echo -e ""
