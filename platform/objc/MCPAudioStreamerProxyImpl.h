#import <AVFoundation/AVFoundation.h>
#import <MCPAudioStreamerProxy.h>

@interface MCPAudioStreamerProxyImpl : NSObject <MCPAudioStreamerProxy>

+ (instancetype)proxy;

@end
