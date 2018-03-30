//
//  ViewController.m
//  OutlastDotGame
//
//  Created by Eric Mcallister on 29/04/2014.
//  Copyright (c) 2014 ERIC. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize twButton, fbButton;
int counter = 0;
- (void)viewDidLoad{
    [super viewDidLoad];
    delegate = [[AppDelegate alloc] init];
    delegate.currentlyPaused = NO;
    delegate.viewController = self;
    [self.navigationController.navigationBar setHidden:YES];
    [countDown retain];
    [pauseButton setHidden:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.hidesBackButton = YES;
        // Configure the view.
        SKView *skView = (SKView *)self.view;
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        skView.backgroundColor = [UIColor whiteColor];
        
        // Create and configure the scene.
        scene = [[MyScene alloc] initWithSize:skView.frame.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.owner = self;
//        scene.backgroundColor = [UIColor blackColor];
        
    // Present the scene.
    [skView presentScene:scene];
    ////
    pauseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 41, 38)];
    [pauseButton setImage:[UIImage imageNamed:@"btPause.png"] forState:UIControlStateNormal];
    [pauseButton setImageEdgeInsets:UIEdgeInsetsMake(8, 10, 9, 10)];
    [pauseButton addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:pauseButton];
    ////
    pauseBlackout = [[UIImageView alloc] initWithFrame:self.view.frame];
    [pauseBlackout setImage:[UIImage imageNamed:@"Black.png"]];
    [self.view addSubview:pauseBlackout];
    [pauseBlackout setAlpha:0.5];
    [pauseBlackout setHidden:YES];
    ////
    isPaused = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - (45/2), self.view.frame.size.height/2 - (63/2), 45, 63)];
    [isPaused setBackgroundImage:[UIImage imageNamed:@"bt_resume.png"] forState:UIControlStateNormal];
    [isPaused addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:isPaused];
    [isPaused setHidden:YES];
    ////
    
    //// HEIGHT DEPENDANT DEAD STUFF BELOW
    
    float h = self.view.frame.size.height;
    float heightShift = ((h - 430)/138) * 52;
    
    self.twButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 38, 311 + heightShift, 34, 33)];
    [self.twButton setBackgroundImage:[UIImage imageNamed:@"bt_twitter@2x.png"] forState:UIControlStateNormal];
    [self.twButton addTarget:self action:@selector(shareTw:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.twButton];
    self.fbButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) + 4, 311 + heightShift, 34, 33)];
    [self.fbButton setBackgroundImage:[UIImage imageNamed:@"bt_fbook.png"] forState:UIControlStateNormal];
    [self.fbButton addTarget:self action:@selector(shareFb:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.fbButton];
    [self.fbButton setHidden:YES];
    [self.twButton setHidden:YES];
    ////
    deadLine = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 55, 254 + heightShift, 110, 2)];
    deadLine.image = [UIImage imageNamed:@"deadline.png"];
    [self.view addSubview:deadLine];
    [deadLine setHidden:YES];
    ////
    countLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 100, 110 + heightShift, 200, 100)];
    [countLabel setTextAlignment:NSTextAlignmentCenter];
    [countLabel setFont:[UIFont fontWithName:@"Dense-Regular" size:100]];
    countLabel.textColor = [UIColor whiteColor];
    [countLabel setHidden:YES];
    [self.view addSubview:countLabel];
    ////
    deadLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 34, 270 + heightShift, 75, 26)];
    [deadLabel setFont:[UIFont fontWithName:@"Dense-Regular" size:26]];
    deadLabel.textColor = [UIColor whiteColor];
    [deadLabel setText:@"SCORE:"];
    [deadLabel setHidden:YES];
    [self.view addSubview:deadLabel];
    ////
    deadLabelScore = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 34, 270 + heightShift, 75, 26)];
    [deadLabelScore setFont:[UIFont fontWithName:@"Dense-Regular" size:26]];
    deadLabelScore.textColor = [UIColor whiteColor];
    [deadLabelScore setTextAlignment:NSTextAlignmentRight];
    [deadLabelScore setHidden:YES];
    [self.view addSubview:deadLabelScore];
    ////
    deadHigh = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 45, 219 + heightShift, 75, 26)];
    [deadHigh setFont:[UIFont fontWithName:@"Dense-Regular" size:26]];
    deadHigh.textColor = [UIColor whiteColor];
    [deadHigh setText:@"HI-SCORE:"];
    [deadHigh setHidden:YES];
    [self.view addSubview:deadHigh];
    ////
    deadHighScore = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 29, 219 + heightShift, 75, 26)];
    [deadHighScore setFont:[UIFont fontWithName:@"Dense-Regular" size:26]];
    deadHighScore.textColor = [UIColor whiteColor];
    [deadHighScore setTextAlignment:NSTextAlignmentRight];
    [deadHighScore setHidden:YES];
    [self.view addSubview:deadHighScore];
    ////
}

-(IBAction)unwindToGame:(UIStoryboardSegue *)unwindSegue{
//    UIViewController *source = unwindSegue.sourceViewController;
    //    [self performSegueWithIdentifier:@"unwindToGame" sender:self];
    [self.navigationController.navigationBar setHidden:NO];
    [pauseButton setHidden:NO];
    [deadLine setHidden:YES];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //    [pauseButton removeFromSuperview];
    [deadLine setHidden:YES];
    [pauseButton setHidden:YES];
}

-(IBAction)pause{
    [scene pause];
    delegate.currentlyPaused = scene.isPaused;
    if(isPaused.isHidden){
        [teleportIcon setHidden:YES];
        [isPaused setHidden:NO];
        [pauseBlackout setHidden:NO];
        [pauseButton setImage:[UIImage imageNamed:@"btPause.png"] forState:UIControlStateNormal];
        [self.instructionButton setHidden:NO];
        [self.view bringSubviewToFront:self.instructionButton];
    } else{
        [self.fbButton setHidden:YES];
        [self.twButton setHidden:YES];
        [teleportIcon setHidden:NO];
        [isPaused setHidden:YES];
        [pauseBlackout setHidden:YES];
        [pauseButton setImage:[UIImage imageNamed:@"btPause.png"] forState:UIControlStateNormal];
        [self.instructionButton setHidden:YES];
        [deadLine setHidden:YES];
    }
}

-(IBAction)shareTw:(int)score{
    [countDown invalidate];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Yes! %i! #infiniteDrift", scene.score]];
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
            scene.isPaused = YES;
            [pauseBlackout setHidden:NO];
            [pauseButton setUserInteractionEnabled:NO];
            [self.twButton setHidden:NO];
            [self.fbButton setHidden:NO];
            [self.view bringSubviewToFront:twButton];
            [self.view bringSubviewToFront:fbButton];
            countLabel.text = [NSString stringWithFormat:@"%i", counter];
            deadLabelScore.text = [NSString stringWithFormat:@"%i", scene.score];
            deadHighScore.text = [NSString stringWithFormat:@"%i", scene.highScore];
            countDown = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(countDownDead)
                                                       userInfo:nil
                                                        repeats:YES];
        }];
        [self presentViewController:mySLComposerSheet animated:YES completion:^(){
        }];
    }
}

-(IBAction)shareFb:(int)score{
    [countDown invalidate];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Yes! %i! #infiniteDrift", scene.score]];
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
            scene.isPaused = YES;
            [pauseBlackout setHidden:NO];
            [pauseButton setUserInteractionEnabled:NO];
            [self.twButton setHidden:NO];
            [self.fbButton setHidden:NO];
            [self.view bringSubviewToFront:twButton];
            [self.view bringSubviewToFront:fbButton];
            countLabel.text = [NSString stringWithFormat:@"%i", counter];
            deadLabelScore.text = [NSString stringWithFormat:@"%i", scene.score];
            deadHighScore.text = [NSString stringWithFormat:@"%i", scene.highScore];
            countDown = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(countDownDead)
                                                       userInfo:nil
                                                        repeats:YES];
        }];
        [self presentViewController:mySLComposerSheet animated:YES completion:^(){
        }];
    }
}

-(void)gameOverCalled{
    NSLog(@"Died");
    counter = 5;
    countLabel.text = [NSString stringWithFormat:@"%i", counter];
    deadLabelScore.text = [NSString stringWithFormat:@"%i", scene.score];
    deadHighScore.text = [NSString stringWithFormat:@"%i", scene.highScore];
    scene.isPaused = YES;
    [deadLine setHidden:NO];
    [countLabel setHidden:NO];
    [deadLabel setHidden:NO];
    [deadLabelScore setHidden:NO];
    [deadHigh setHidden:NO];
    [deadHighScore setHidden:NO];
    [pauseBlackout setHidden:NO];
    [pauseButton setUserInteractionEnabled:NO];
    [self.twButton setHidden:NO];
    [self.fbButton setHidden:NO];
    [self.view bringSubviewToFront:twButton];
    [self.view bringSubviewToFront:fbButton];
    countDown = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(countDownDead)
                                               userInfo:nil
                                                repeats:YES];
}

-(void)countDownDead{
    counter --;
    NSLog(@"%i", counter);
    countLabel.text = [NSString stringWithFormat:@"%i", counter];
    if(counter == 0){
        [pauseBlackout setHidden:YES];
        [countLabel setHidden:YES];
        [deadLabel setHidden:YES];
        [self.twButton setHidden:YES];
        [self.fbButton setHidden:YES];
        [deadLine setHidden:YES];
        [deadLabel setHidden:YES];
        [deadLabelScore setHidden:YES];
        [deadHigh setHidden:YES];
        [deadHighScore setHidden:YES];
        [scene initiateGame];
        scene.isPaused = NO;
    } else if(counter == -1){
        [pauseButton setUserInteractionEnabled:YES];
        [countDown invalidate];
    } else{
        [pauseButton setUserInteractionEnabled:NO];
        scene.isPaused = YES;
    }
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
