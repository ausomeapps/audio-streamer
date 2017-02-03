# AudioStreamer

The AudioStreamer is a cross-platform audio streaming player for iOS and Android that uses Djinni and CMake to create a consistent high-level interface for wrapping the platform-specific proxy implementations.

In the [Mobile C++ video series](https://www.syedharisali.com/mobilecpp) this serves as the primary **bidirectional** example. In this instance we're using Djinni to call platform specific implementations of the audio player, which is then accessible through the `AudioStreamer` (or `MCPAudioStreamer` on iOS) class's singleton reference.


## Build Instructions
To build the AudioStreamer library for iOS and Android follow the instructions below to generate the appropriate `AudioStreamer.framework` (iOS) or proper Android Studio CMake integration (Android). The `CMakeLists.txt` file should take care of generating the libraries and handling all internal linking of the sub-dependencies (such as djinni)

### Cloning the repo
You're going to want to clone this repo recursively to get the submodules for djinni and polly (we're using custom forks from the Mobile C++ organization)
```
git clone --recursive https://github.com/mobilecpp/audio-streamer.git
```

If you've already cloned the repo then you can update the submodules like so:
```
git submodule update --init --recursive
```

### iOS

There's a helper script to build a universal `AudioStreamer.framework` that can be used for all the valid device and simulator architectures (x86_64 i386 armv7 armv7s arm64).
```
cd scripts && ./build_ios.sh
```

#### Requirements
- CMake 3.1 (minimum)
- Xcode 8
- iOS 10.2
- macOS 10.12
- A valid "iPhone Developer" code signing identity

Once successfully built the universal `AudioStreamer.framework` and `libdjinni.a` library will be available in the `libs` folder under the target device (iOS or macos). From this point the two can simply be dragged and dropped into a project or added by reference.

#### Notes

Ensure the `AudioStreamer.framework` for iOS or macOS is in the `Embedded Binaries`.
![Embedded binaries](https://cloud.githubusercontent.com/assets/1275640/22579002/746b81da-e992-11e6-970a-a30f8e5daf1c.png)

Additionally, if you aren't copying the `AudioStreamer.framework` and `libdjinni.a` library into your project then you're going to need to modify the `Search Paths` in the `Build Settings` to set the framework and library search paths to the libs/ios or lib/macos output directory.
![Search Paths](https://cloud.githubusercontent.com/assets/1275640/22579048/c9be2c5a-e992-11e6-8f02-032a7773223f.png)
**Note:** You only need to do this if you're adding the `AudioStreamer.framework` and `libdjinni.a` library by *reference* and not copying it into your app.

Alternatively, you can just run the CMakeLists.txt to generate a `AudioStreamer.framework` target for whatever toolchain you'd like to compile against.

#### macOS

In a similar fashion as iOS, a macOS framework can also be built. Check out the `build_macos.sh` script to see how we can also compile the `AudioStreamer.framework` for macOS.
```
cd scripts && ./build_macos.sh
```

### Android
```
TODO
```
