#import "MCPAudioStreamerProxy.h"
#import <AVFoundation/AVFoundation.h>

//
// The MCPAudioStreamerProxyImpl implements the MCPAudioStreamerProxy protocol
// using an internal AVPlayer.
//
@interface MCPAudioStreamerProxyImpl : NSObject <MCPAudioStreamerProxy>

//
// An class method to provide an instance of the MCPAudioStreamerProxyImpl
// class.
//
+ (instancetype)proxy;

@end
