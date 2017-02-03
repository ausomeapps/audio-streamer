#!/bin/bash

base_dir=$(cd "`dirname "0"`" && pwd)/..
build_dir=$base_dir/build/ios
generated_src_dir=$base_dir/generated-src
lib_dir=$base_dir/lib/ios
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
cmake ../.. -GXcode -DCMAKE_TOOLCHAIN_FILE=$polly_dir/ios-10-2.cmake -DCMAKE_VERBOSE_MAKEFILE=ON;
echo -e ""

echo -e "--------------------------------------------------------"
echo -e "-- Compiling AudioStreamer library (and dependencies) --"
echo -e "--------------------------------------------------------\n"
xcodebuild -target AudioStreamer -configuration Release -arch arm64 -arch armv7 -arch armv7s only_active_arch=no defines_module=yes -sdk "iphoneos"
xcodebuild -target AudioStreamer -configuration Release -arch x86_64 -arch i386 only_active_arch=no defines_module=yes -sdk "iphonesimulator"
echo -e "Success\n"

echo -e "-------------------------------------------------"
echo -e "-- Creating AudioStreamer.framework FAT binary --"
echo -e "-------------------------------------------------\n"
cp -R Release-iphoneos/AudioStreamer.framework $lib_dir
lipo -create -output $lib_dir/AudioStreamer.framework/AudioStreamer Release-iphoneos/AudioStreamer.framework/AudioStreamer Release-iphonesimulator/AudioStreamer.framework/AudioStreamer
echo -e "Success: \n" $lib_dir/AudioStreamer.framework "\n"

echo -e "---------------------------------------------------"
echo -e "-- Validating AudioStreamer.framework FAT binary --"
echo -e "---------------------------------------------------\n"
lipo -info $lib_dir/AudioStreamer.framework/AudioStreamer
echo -e ""

echo -e "------------------------------------------"
echo -e "-- Creating djinni.framework FAT binary --"
echo -e "------------------------------------------\n"
cd deps/djinni
cp -R Release-iphoneos/djinni.framework $lib_dir
lipo -create -output $lib_dir/djinni.framework/djinni Release-iphoneos/djinni.framework/djinni Release-iphonesimulator/djinni.framework/djinni
echo -e "Success: \n" $lib_dir/djinni.framework "\n"

echo -e "--------------------------------------------"
echo -e "-- Validating djinni.framework FAT binary --"
echo -e "--------------------------------------------\n"
lipo -info $lib_dir/djinni.framework/djinni
echo -e ""
