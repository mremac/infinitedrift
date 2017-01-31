//
//  InstructionViewController.m
//  OutlastDotGame
//
//  Created by Eric Mcallister on 02/07/2014.
//  Copyright (c) 2014 ERIC. All rights reserved.
//

#import "InstructionViewController.h"

@interface InstructionViewController ()

@end

@implementation InstructionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count - 2] isKindOfClass:[FirstViewViewController class]]){
        [self.button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self.button addTarget:self action:@selector(segueToGame) forControlEvents:UIControlEventTouchDown];
    }
    [self.navigationController.navigationBar setHidden:YES];
    // Do any additional setup after loading the view.
}

- (void) viewDidLayoutSubviews
{
    self.view.autoresizesSubviews = NO;
    float h = self.view.frame.size.height;
    float r = (h - 430)/138;
    CGRect newButtonPos = CGRectMake(self.button.frame.origin.x, h - (self.button.frame.size.height + 26 + (18*r)), self.button.frame.size.width, self.button.frame.size.height);
    [self.button setFrame: newButtonPos];
    CGRect newInstructPos = CGRectMake(self.theInstructions.frame.origin.x, 11 + (59*r), self.theInstructions.frame.size.width, self.theInstructions.frame.size.height);
    [self.theInstructions setFrame: newInstructPos];
    NSLog(@"%f : %f",newInstructPos.origin.y,newButtonPos.origin.y);
}

-(IBAction)segueToGame{
    [self performSegueWithIdentifier:@"First segue" sender:self];
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
