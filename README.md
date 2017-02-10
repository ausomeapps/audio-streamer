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

For Android all you need to do is simply copy or add this repo as a submodule to your existing Android Studio project. There are, however, a couple things to note.

#### Requirements
- Android Studio 2.3 or later
- Project must have C++ support enabled (checkmark when you're creating the project)
- You must enable C++11 instead of the default toolchain
- Enable exception and rtti

#### Notes

Ensure in your `AndroidManifest.xml` you've added the user permissino for internet like so:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

In the bottom example we made a folder called `deps` and recursively cloned the `audio-streamer` repo into it as a submodule.
![adding-deps](https://cloud.githubusercontent.com/assets/1275640/22806681/e06f4802-eee8-11e6-8764-ab06039256a1.png)
```
git submodule add https://github.com/mobilecpp/audio-streamer.git audio-streamer
git submodule update --init --recursive
```

Go into the `audio-streamer` folder and run the djinni script.
```
cd deps/audio-streamer
cd scripts && ./run_djinni.sh
```

Next go into your app's `build.gradle` file and add the java source sets from the audio-streamer. If you have placed the audio-streamer folder in a different location than your app's deps folder like above then you should modify the paths below to reflect your project's structure.
![adding-java-src](https://cloud.githubusercontent.com/assets/1275640/22806682/e06f892a-eee8-11e6-8aa5-88ee1aaf2cc2.png)

Once this is complete you will need to resync gradle. Afterwards, you should see the java classes from the AudioStreamer in your project:

![java-src](https://cloud.githubusercontent.com/assets/1275640/22807082/d8b5ffc8-eeea-11e6-8eb5-e2db8802a096.png)

In the top menu go to Build and click Refresh Linked C++ Projects. You should now see the libraries in the cpp folder and additional `CMakeLists.txt` files in the `External Build Files` section of the project pane.
![list-of-libs](https://cloud.githubusercontent.com/assets/1275640/22806684/e07b9e68-eee8-11e6-88a3-f910d9104726.png)

![list-of-cmakes](https://cloud.githubusercontent.com/assets/1275640/22806680/e06f228c-eee8-11e6-96da-ecc7184fcc40.png)

Next, we actually load the library into the MainActivity (or another other activity that will actually use this class) by adding the following to the top of the class.
```java
static {
    System.loadLibrary("AudioStreamer");
}
```

See the Android sample in the examples folder to see how to use another path structure incase you'd like to keep the audio-streamer folder in a different location.
