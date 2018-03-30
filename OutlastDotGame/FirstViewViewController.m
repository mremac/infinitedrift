//
//  FirstViewViewController.m
//  OutlastDotGame
//
//  Created by Martin McAllister on 28/05/2014.
//  Copyright (c) 2014 ERIC. All rights reserved.
//

#import "FirstViewViewController.h"


@implementation FirstViewViewController
@synthesize beginTheDrift, scrollLabel;
@synthesize highscore;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom ;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self.navigationController.navigationBar setHidden:YES];
    for (UIView *view in self.navigationController.navigationBar.subviews){
        if(![view isKindOfClass:[UIImageView class]]){
            [view removeFromSuperview];
        }
    }
    if([self isFirstRun]){
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"someOtherShitID"];
        [self performSegueWithIdentifier:@"SEGUE" sender:self];
    }
}

-(void)viewDidLayoutSubviews
{
    self.view.autoresizesSubviews = NO;
    
    //// HEIGHT DEPENDANT STUFF BELOW
    
    float h = self.view.frame.size.height;
    float heightShift = (((h - 430)/138) * 95)+105;
    
    ////
    CGRect newButtonPos = CGRectMake(self.view.frame.size.width/2 - beginTheDrift.frame.size.width/2, heightShift, beginTheDrift.frame.size.width, beginTheDrift.frame.size.height);
    [beginTheDrift setFrame:newButtonPos];
    ////
    self.twButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 38, 161 + heightShift, 34, 33)];
    [self.twButton setBackgroundImage:[UIImage imageNamed:@"bt_twitter@2x.png"] forState:UIControlStateNormal];
    [self.twButton addTarget:self action:@selector(shareTw:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.twButton];
    self.fbButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) + 4, 161 + heightShift, 34, 33)];
    [self.fbButton setBackgroundImage:[UIImage imageNamed:@"bt_fbook.png"] forState:UIControlStateNormal];
    [self.fbButton addTarget:self action:@selector(shareFb:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.fbButton];
    ////
    deadLine = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 55, 112 + heightShift, 110, 2)];
    deadLine.image = [UIImage imageNamed:@"deadline.png"];
    [self.view addSubview:deadLine];
    ////
    high = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 45, 127 + heightShift, 75, 26)];
    [high setFont:[UIFont fontWithName:@"Dense-Regular" size:26]];
    high.textColor = [UIColor whiteColor];
    [high setText:@"HI-SCORE:"];
    [self.view addSubview:high];
    ////bg.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    highscore = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 29
                                                         , 127 + heightShift, 75, 26)];
    [highscore setFont:[UIFont fontWithName:@"Dense-Regular" size:26]];
    highscore.textColor = [UIColor whiteColor];
    [highscore setTextAlignment:NSTextAlignmentRight];
    [highscore setText:[NSString stringWithFormat:@"%li", (long)[self.defaults integerForKey:@"High Score"]]];
    [self.view addSubview:highscore];
    ////
}


-(IBAction)shareTw:(int)score{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Yes! %li! #infiniteDrift", (long)[self.defaults integerForKey:@"High Score"]]];
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];
        [self presentViewController:mySLComposerSheet animated:YES completion:^(){
        }];
    }
}

-(IBAction)shareFb:(int)score{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Yes! %li! #infiniteDrift", (long)[self.defaults integerForKey:@"High Score"]]];
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];
        [self presentViewController:mySLComposerSheet animated:YES completion:^(){
        }];
    }
}

- (BOOL) isFirstRun
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"isFirstRun"])
    {
        return NO;
    }
    
    [defaults setObject:[NSDate date] forKey:@"isFirstRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
