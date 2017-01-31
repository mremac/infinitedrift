//
//  InstructionViewController.h
//  OutlastDotGame
//
//  Created by Eric Mcallister on 02/07/2014.
//  Copyright (c) 2014 ERIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "FirstViewViewController.h"
#import "ViewController.h"

@interface InstructionViewController : UIViewController <ADBannerViewDelegate>
@property IBOutlet UIButton *button;
@property IBOutlet UIImageView *theInstructions;
@end
