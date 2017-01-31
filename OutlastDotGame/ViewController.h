//
//  ViewController.h
//  OutlastDotGame
//

//  Copyright (c) 2014 ERIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>
#import <Social/Social.h>
#import "MyScene.h"
#import "AppDelegate.h"

@interface ViewController : UIViewController <NSCacheDelegate, ADBannerViewDelegate>{
    MyScene *scene;
    UIImageView *teleportIcon;
    UIImageView *instructions;
    UIView *shareView;
    UIButton *isPaused;
    UILabel *deadLabel;
    UILabel *deadHigh;
    UILabel *deadHighScore;
    UILabel *deadLabelScore;
    UILabel *countLabel;
    UIImageView *pauseBlackout;
    UIImageView *deadLine;
    UIButton *pauseButton;
    NSTimer *countDown;
    AppDelegate *delegate;
}
-(IBAction)pause;
-(IBAction)shareTw:(int)score;
-(IBAction)shareFb:(int)score;
-(IBAction)unwindToGame:(UIStoryboardSegue *)unwindSegue;
-(void)gameOverCalled;
@property (strong, nonatomic) IBOutlet UIButton *instructionButton;
@property (nonatomic, retain) UIButton *twButton, *fbButton;

@end
