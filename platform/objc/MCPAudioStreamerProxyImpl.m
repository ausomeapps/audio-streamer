#import <MCPAudioStreamerProxyImpl.h>

@interface MCPAudioStreamerProxyImpl ()
@property (strong) AVPlayer *player;
@end

@implementation MCPAudioStreamerProxyImpl

//------------------------------------------------------------------------------
#pragma mark - Class Initializer
//------------------------------------------------------------------------------

+ (instancetype)proxy {
    return [[self alloc] init];
}

//------------------------------------------------------------------------------
#pragma mark - Initialization
//------------------------------------------------------------------------------

- (instancetype) init {
    self = [super init];
    if (self) {
        self.player = [[AVPlayer alloc] init];
    }
    return self;
}

//------------------------------------------------------------------------------
#pragma mark - MCPAudioStreamerProxyImpl
//------------------------------------------------------------------------------

- (NSString *)url {
    AVAsset *currentPlayerAsset = self.player.currentItem.asset;
    if (![currentPlayerAsset isKindOfClass:AVURLAsset.class]) {
        return nil;
    }
    return [[(AVURLAsset *)currentPlayerAsset URL] absoluteString];
}

//------------------------------------------------------------------------------

- (void)setUrl:(NSString *)url {
    NSLog(@"Setting url: %@", url);
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
    [self.player replaceCurrentItemWithPlayerItem:item];
}

//------------------------------------------------------------------------------

- (BOOL)isPlaying {
    return self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying;
}

//------------------------------------------------------------------------------

- (void)play {
    NSLog(@"Player [%@]: is playing: %@", self.player, [self url]);
    [self.player play];
}

//------------------------------------------------------------------------------

- (void)pause {
    [self.player pause];
}

@end
