//
//  ViewController.h
//  AudioStreamerExample
//
//  Created by Syed Haris Ali on 2/9/17.
//  Copyright © 2017 Syed Haris Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

//------------------------------------------------------------------------------
#pragma mark - ViewController
//------------------------------------------------------------------------------

@interface ViewController : UIViewController

//------------------------------------------------------------------------------
#pragma mark - Properties
//------------------------------------------------------------------------------

@property (weak, nonatomic) IBOutlet UIButton *playButton;

//------------------------------------------------------------------------------
#pragma mark - Instance Methods
//------------------------------------------------------------------------------

- (IBAction)play:(id)sender;

@end

