//
//  FirstViewViewController.h
//  OutlastDotGame
//
//  Created by Martin McAllister on 28/05/2014.
//  Copyright (c) 2014 ERIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <iAd/iAd.h>

@interface FirstViewViewController : UIViewController <ADBannerViewDelegate>{
    UIImageView *deadLine;
    UILabel *high, *highscore;
}
@property (strong, nonatomic) IBOutlet UIButton *beginTheDrift;
@property (strong, nonatomic) IBOutlet UILabel *scrollLabel;
@property (nonatomic, retain) IBOutlet UILabel *highscore;
@property NSUserDefaults *defaults;
-(IBAction)shareTw:(int)score;
-(IBAction)shareFb:(int)score;
@property (strong, nonatomic) IBOutlet UIButton *instructionButton;
@property (nonatomic, retain) UIButton *twButton, *fbButton;

@end
