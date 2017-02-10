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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Setup the AVAudioSession. EZMicrophone will not work properly on iOS
    // if you don't do this!
    //
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
    
    __block NSString *url = @"http://a165.phobos.apple.com/us/r30/Music3/v4/1b/a1/00/1ba10045-5bfe-1eda-361f-2f0752a6b943/mzaf_1919196824342540066.plus.aac.p.m4a";
    MCPAudioStreamerProxyImpl *proxy = [MCPAudioStreamerProxyImpl proxy];
    MCPAudioStreamer.sharedInstance.proxy = proxy;
    MCPAudioStreamer.sharedInstance.url = url;
    [MCPAudioStreamer.sharedInstance play];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        url = @"http://a890.phobos.apple.com/us/r1000/086/Music/v4/9d/df/d9/9ddfd90a-34d7-989f-422e-753cc53ca9fc/mzaf_7579162302371443805.aac.m4a";
        [MCPAudioStreamer.sharedInstance pause];
        MCPAudioStreamer.sharedInstance.url = url;
        [MCPAudioStreamer.sharedInstance play];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
