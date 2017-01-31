//
//  MyScene.h
//  OutlastDotGame
//

//  Copyright (c) 2014 ERIC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKNestSprite.h"
#import "AppDelegate.h"

#define background -5
#define middleground 15
#define foreground 20

@interface MyScene : SKScene{
    CGPoint touchPoint;
    SKSpriteNode *hero;
    float x;
    float y;
    float dx;
    float dy;
    float tdx;
    float tdy;
    float px;
    float py;
    float hyp;
    int prevScore;
    //SKNestSprite *nest;
}
@property int constant;
@property int yConstant;
@property int score, noOfTeleports;
@property int highScore;
@property BOOL isPaused;
@property BOOL isTeleporting;
@property (nonatomic, retain) NSUserDefaults *defaults;
@property (nonatomic, retain) SKLabelNode *scores, *myLabel, *teleports;
@property (nonatomic, retain) UIViewController *owner;
@property (strong, retain) SKTextureAtlas *deathTextures, *heroTeleportTextures, *getPointTextures;
-(void)createPointAtPos:(CGPoint)pointPos;
-(void)pause;
-(void)initiateGame;
@end
