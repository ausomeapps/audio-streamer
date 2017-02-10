//
//  ViewController.m
//  AudioStreamerExample
//
//  Created by Syed Haris Ali on 2/9/17.
//  Copyright © 2017 Syed Haris Ali. All rights reserved.
//

#import "ViewController.h"
#import <AudioStreamer/MCPAudioStreamer.h>
#import <AudioStreamer/MCPAudioStreamerProxyImpl.h>

//------------------------------------------------------------------------------
#pragma mark - Constants
//------------------------------------------------------------------------------

NSString * const STREAM_URL = @"http://a935.phobos.apple.com/us/r30/Music/53/6f/d8/mzm.eslehvlz.aac.p.m4a";

//------------------------------------------------------------------------------
#pragma mark - ViewController (Implementation)
//------------------------------------------------------------------------------

@implementation ViewController

//------------------------------------------------------------------------------
#pragma mark - View Lifecycle
//------------------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Setup the AVAudioSession for playback
    //
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSLog(@"Error setting up audio session category: %@",
              error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error) {
        NSLog(@"Error setting up audio session active: %@",
              error.localizedDescription);
    }
    
    //
    // Setup the streamer with the proxy implementation and set the URL to
    // the STREAM_URL we defined above
    //
    MCPAudioStreamer *sharedStreamer = [MCPAudioStreamer sharedInstance];
    MCPAudioStreamerProxyImpl *proxy = [MCPAudioStreamerProxyImpl proxy];
    [sharedStreamer setProxy:proxy];
    [sharedStreamer setUrl:STREAM_URL];
}

//------------------------------------------------------------------------------
#pragma mark - Instance Methods
//------------------------------------------------------------------------------

- (void)play:(id)sender {
    MCPAudioStreamer *sharedStreamer = [MCPAudioStreamer sharedInstance];
    if ([sharedStreamer isPlaying]) {
        [sharedStreamer pause];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    else {
        [sharedStreamer play];
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

@end
