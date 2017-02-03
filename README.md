# AudioStreamer

The AudioStreamer is a cross-platform audio streaming player for iOS and Android that uses Djinni and CMake to create a consistent high-level interface for wrapping the platform-specific proxy implementations.

In the Mobile C++ course this serves as the primary **bidirectional** example. In this instance we're using Djinni to call platform specific implementations of the audio player, which is then accessible through the AudioStreamer's (or MCPAudioStreamer on iOS) singleton reference.

## Build Instructions
To build the AudioStreamer library for iOS and Android follow the instructions below to generate the appropriate .framework (iOS) or .so s(Android) library to link against. The CMakeLists.txt file should take care of generating the libraries and handling all internal linking of the sub-dependencies (such as djinni)

### iOS
```
TODO
```

### Android
```
TODO
```
