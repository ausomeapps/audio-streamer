#import "MCPAudioStreamerProxy.h"
#import <AVFoundation/AVFoundation.h>

@interface MCPAudioStreamerProxyImpl : NSObject <MCPAudioStreamerProxy>

+ (instancetype)proxy;

@end
