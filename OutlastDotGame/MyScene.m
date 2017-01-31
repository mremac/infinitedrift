//
//  MyScene.m
//  OutlastDotGame
//
//  Created by Eric Mcallister on 29/04/2014.
//  Copyright (c) 2014 ERIC. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene {
    UITapGestureRecognizer *doubleTap;
    CGFloat ranx;
    CGFloat rany;
    NSMutableArray *texturesTeleportOut, *texturesTeleportIn, *texturesCellDeath, *getPointAni;
}
@synthesize constant;
@synthesize yConstant;
@synthesize score, highScore;
@synthesize isPaused;
@synthesize owner;

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.isTeleporting = false;
        tdx = 0;
        tdy = 0;
        self.constant = size.width;
        self.yConstant = size.height;
        self.heroTeleportTextures = [[SKTextureAtlas alloc]init];
        [self.heroTeleportTextures retain];
        self.heroTeleportTextures = [SKTextureAtlas atlasNamed:@"_animations"];
        self.deathTextures = [[SKTextureAtlas alloc] init];
        [self.deathTextures retain];
        self.deathTextures = [SKTextureAtlas atlasNamed:@"_baddie"];
        self.getPointTextures = [[SKTextureAtlas alloc] init];
        [self.getPointTextures retain];
        self.getPointTextures = [SKTextureAtlas atlasNamed:@"_mypoints"];
        
        // Moved building the animations up to here so they only get called once, rather than everytime the method is called.
        texturesTeleportIn = [[NSMutableArray alloc]init];
        texturesTeleportOut = [[NSMutableArray alloc]init];
        for(int textureInt = 1; textureInt < 13; textureInt ++){
            [texturesTeleportIn addObject:[self.heroTeleportTextures textureNamed:[NSString stringWithFormat:@"heroTeleport%i.png", textureInt]]];
            [texturesTeleportOut addObject:[self.heroTeleportTextures textureNamed:[NSString stringWithFormat:@"heroTeleport%lu.png", self.heroTeleportTextures.textureNames.count/2 - textureInt]]];
        }
        texturesCellDeath = [[NSMutableArray alloc]init];
        [texturesCellDeath addObject:[self.deathTextures textureNamed:@"celldeathA.png"]];
        [texturesCellDeath addObject:[self.deathTextures textureNamed:@"celldeathB.png"]];
        for(int textureInt = 1; textureInt < 12; textureInt ++){
            [texturesCellDeath addObject:[self.deathTextures textureNamed:[NSString stringWithFormat:@"celldeath00%i.png", textureInt]]];
        }
        getPointAni = [[NSMutableArray alloc]init];
        for(int textureInt = 1; textureInt < 3; textureInt ++){
            [getPointAni addObject:[self.getPointTextures textureNamed:[NSString stringWithFormat:@"point-vanish%i.png", textureInt]]];
        }
        
        [self initiateGame];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view{
    doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teleport)];
    doubleTap.numberOfTapsRequired = 2;
    
    [view addGestureRecognizer:doubleTap];
    
}

-(void)willMoveFromView:(SKView *)view{
    [view removeGestureRecognizer:doubleTap];
}

-(void)teleport{
    if(self.noOfTeleports>0 && !self.isPaused){
        
        [texturesTeleportOut addObject:[SKTexture textureWithImageNamed:@"hero.png"]];
        self.noOfTeleports--;
        [self.teleports setText:[NSString stringWithFormat:@"TELEPORTS: %i", self.noOfTeleports]];
        self.isTeleporting = true;
        [self runAction:[SKAction playSoundFileNamed:@"teleport.wav" waitForCompletion:NO]];
        SKAction *animateTeleportOut = [SKAction animateWithTextures:texturesTeleportIn timePerFrame:0.04];
        SKAction *animateTeleportIn = [SKAction animateWithTextures:texturesTeleportOut timePerFrame:0.04];
        SKSpriteNode *tempHero = [SKSpriteNode spriteNodeWithImageNamed:@"hero.png"];
        [tempHero setPosition:CGPointMake(hero.position.x, hero.position.y)];
        [tempHero setSize:CGSizeMake(hero.size.width, hero.size.height)];
        [tempHero setZRotation:hero.zRotation];
        [self addChild:tempHero];
        [tempHero runAction:animateTeleportOut completion:^(){
            [tempHero removeFromParent];
//            [tempHero dealloc];
        }];
        [hero setPosition:CGPointMake(touchPoint.x, touchPoint.y)];
        [hero runAction:animateTeleportIn completion:^(){
            self.isTeleporting = NO;
            tdx = 0;
            tdy = 0;
        }];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        touchPoint = [touch locationInNode:self];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch moves */
    for (UITouch *touch in touches) {
        CGPoint t = [touch locationInNode:self];
        touchPoint = CGPointMake(t.x, t.y+40);
    }
}

-(void)update:(CFTimeInterval)currentTime {
    if(!self.isPaused){
        [self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
//        Scrolling, calling randomGenerate method, making PLAYER follow touch
        
    // CALC MOVE FOR HERO
    x = hero.position.x;
    y = hero.position.y;
    dx = touchPoint.x - x;
    dy = touchPoint.y - y;
    hyp = sqrtf(powf(dx, 2) + powf(dy, 2));
    if(self.isTeleporting){
        if(tdx == 0 && tdy == 0){
            tdx = dx;
            tdy = dy;
        }
            px = tdx/40;
            py = tdy/40;
    } else{
        px = 2*dx/hyp;
        py = 2*dy/hyp;
    }
    float relativeMotionX = 0;
    float relativeMotionY = 0;
    if(hyp > 2){
        if(hero.position.x + px < self.constant/16 || hero.position.x + px > 15*self.constant/16){
            relativeMotionX = px;
            if(!self.isTeleporting){
                [self randomGenerate];
            }
        } else if(hero.position.x + px >= self.constant/16 && hero.position.x + px <= 15*self.constant/16){
            x += px;
        }
        if(hero.position.y + py < 3*self.yConstant/16 || hero.position.y + py > 13*self.yConstant/16){
            relativeMotionY = py;
            if(!self.isTeleporting){
                [self randomGenerate];
            }
        } else if(hero.position.y + py >= 3*self.yConstant/16 && hero.position.y + py <= 13*self.yConstant/16){
            y += py;
        }
    }
        float resetX = x;
        float resetY = y;
        if(x < self.constant/16){
            resetX = self.constant/16;
        } else if(x > 15*self.constant/16){
            resetX = 15*self.constant/16;
        }
        if(y < 3*self.yConstant/16){
            resetY = 3*self.yConstant/16;
        } else if(y > 13*self.yConstant/16){
            resetY = 13*self.yConstant/16;
        }
        x = resetX;
        y = resetY;
        //        PLAYER position and rotation to follow touch
        [hero setPosition:CGPointMake(x, y)];
        float touchRotation = atan(-dx/dy);
        if (dy < 0) touchRotation -= M_PI;
        if (touchRotation - hero.zRotation > M_PI || touchRotation - hero.zRotation < -M_PI) hero.zRotation = touchRotation;
        if (dy != 0) hero.zRotation += ((touchRotation-hero.zRotation)/5);
//        Scrolling NESTS, ENEMIES, POINTS. Deleting offscreen Nodes
    for(SKSpriteNode *sprite in self.children){
        if([sprite isKindOfClass:[SKEnemySprite class]] || [sprite isKindOfClass:[SKNestSprite class]] || [sprite isKindOfClass:[SKPointSprite class]]){
            if(sprite.position.x <= -0.5*self.constant || sprite.position.x >= 1.5*self.constant || sprite.position.y <= -0.5*self.yConstant || sprite.position.y >= 1.5*self.yConstant){
                [sprite removeFromParent];
//                [sprite dealloc];
            }
            [sprite setPosition:CGPointMake(sprite.position.x - relativeMotionX, sprite.position.y - relativeMotionY)];
        }
        //            Checking for POINTS contacting PLAYER
        if([sprite isKindOfClass:[SKPointSprite class]]){
            SKPointSprite *point = [[SKPointSprite alloc] init];
            point = sprite;
            [point setZPosition:background];
            if(sqrtf(powf(point.position.x - hero.position.x, 2) + powf(point.position.y - hero.position.y, 2)) < hero.size.height){
                [self runAction:[SKAction playSoundFileNamed:@"point.wav" waitForCompletion:NO]];
                self.score ++;
                SKAction *animatePoint = [SKAction animateWithTextures:getPointAni timePerFrame:0.06];
                SKSpriteNode *tempPoint = [SKSpriteNode spriteNodeWithTexture: [self.getPointTextures textureNamed:@"point-vanish1.png"]];
                [tempPoint setPosition:CGPointMake(point.position.x - 4, point.position.y)];
                [tempPoint setZPosition:point.zPosition];
                [self addChild:tempPoint];
                [sprite removeFromParent];
                [tempPoint runAction:animatePoint completion:^(){
                    [tempPoint removeFromParent];
                }];
                if(self.score >= self.highScore){
                    self.highScore = self.score;
                    [self.defaults setInteger:self.highScore forKey:@"High Score"];
                    [self.defaults synchronize];
                }
                self.myLabel.text = [NSString stringWithFormat:@"%i", self.score];
            }
            sprite = point;
        }
        if([sprite isKindOfClass:[SKNestSprite class]]){
            SKNestSprite * someNest = [[SKNestSprite alloc] init];
            someNest = sprite;
            someNest.zRotation += powf(-0.9, someNest.number)*0.01;
//            Random ENEMY generation
            int randomNum = arc4random() % 5000;
            if(someNest.isRed){
                if(randomNum <= 500*powf(2.0, -someNest.number)){
                    [someNest spawnRandom];
                    [self runAction:[SKAction playSoundFileNamed:@"spawn.wav" waitForCompletion:NO]];
                }
            } else{
            if(randomNum == 1){
                [someNest spawnRandom];
                [self runAction:[SKAction playSoundFileNamed:@"spawn.wav" waitForCompletion:NO]];
            }
            }
            sprite = someNest;
            if(sqrtf(powf(someNest.position.x - hero.position.x, 2) + powf(someNest.position.y - hero.position.y, 2)) <= someNest.size.height/2 + hero.size.height/3.5 && !self.isTeleporting){
                [self gameOver];
                self.isPaused = YES;
            }
        }
        if([sprite isKindOfClass:[SKEnemySprite class]]){
            SKEnemySprite *enemy = [[SKEnemySprite alloc] init];
            enemy = sprite;
            if(!enemy.isDead){
            //[enemy setZPosition:middleground];
            [enemy pursuePoint:hero.position];
            
//            Statements to test for when one ENEMY contacts another
            for(SKEnemySprite *anotherEnemy in self.children){
                if([anotherEnemy isKindOfClass:[SKEnemySprite class]] && anotherEnemy != enemy){
                    if(enemy.isRed == anotherEnemy.isRed){
                    if(sqrtf(powf(enemy.position.x - anotherEnemy.position.x, 2) + powf(enemy.position.y - anotherEnemy.position.y, 2)) <= enemy.size.height/2 && !anotherEnemy.isDead){
                        enemy.esize += anotherEnemy.esize;
//                        Colour change
                        if(enemy.isRed){
                            [enemy setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"baddieR%i@2x", enemy.esize]]];
                        } else{
                            [enemy setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"baddie%i@2x", enemy.esize]]];
                        }
                        [enemy setZPosition:enemy.esize];
                        anotherEnemy.isDead = YES; 
                        [anotherEnemy apoptosis];
                        [anotherEnemy removeFromParent];
                        if(enemy.esize >= 5){
                            if(enemy.isRed){
                                [self createNestAtPos:enemy.position withRed:YES];
                                [sprite removeFromParent];
                            } else{
                            enemy.isDead = YES;
                            NSLog(@"Cell Death");
                            enemy.size = CGSizeMake(1.05*sqrtf(enemy.esize)*self.constant/10, 1.05*sqrtf(enemy.esize)*self.constant/10);
                            SKAction *animateCellDeath = [SKAction animateWithTextures:texturesCellDeath timePerFrame:0.06];
                            [enemy apoptosis];
                            [self runAction:[SKAction playSoundFileNamed:@"implode.wav" waitForCompletion:NO]];
                            [enemy runAction:animateCellDeath completion:^(){
                                [sprite removeFromParent];
                            }];
                            }
                        } else {
                            enemy.growing = YES;
                            [self runAction:[SKAction playSoundFileNamed:@"grow.wav" waitForCompletion:NO]];
                            if(enemy.isRed){
                                SKAction *swapImg = [SKAction setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"baddieR%i@2x.png", enemy.esize]]];
                                [enemy runAction:swapImg];
                            } else{
                                SKAction *swapImg = [SKAction setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"baddie%i@2x.png", enemy.esize]]];
                                [enemy runAction:swapImg];
                            }
                        }
                    }
                    }
                }
            }
//            ENEMY enlarges when another enemy is absorbed
            if(enemy.growing){
                [enemy setSize:CGSizeMake(enemy.size.width + 1, enemy.size.height + 1)];
                if(enemy.size.width >= sqrtf(enemy.esize)*self.constant/10){
                    enemy.growing = NO;
                }
            }
//            Game Over Trigger
            if(sqrtf(powf(enemy.position.x - hero.position.x, 2) + powf(enemy.position.y - hero.position.y, 2)) <= enemy.size.height/3 && !self.isTeleporting){
                [self gameOver];
            }
            }
            sprite = enemy;
        }
    }
    } else{
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    }
}

-(BOOL)checkNestOverlap:(CGPoint)positionOfNest{
    BOOL testFlag = false;
    for(SKNestSprite *someNest in self.children){
        if([someNest isKindOfClass:[SKNestSprite class]]){
            if(sqrtf(powf(someNest.position.x - positionOfNest.x, 2) + powf(someNest.position.y - positionOfNest.y, 2)) <= someNest.size.height){
                testFlag = true;
                break;
            }
        }
    }
    return testFlag;
}

//If you randomly generate two new numbers after having checked a nest off the list, the numbers could result in a point within the frame of that nest. However if you increase ranx by 1 you move the point of the new nest to the right until it is out of danger of overlapping.

-(void)randomGenerate{
    ranx = arc4random() % self.constant;
    ranx += 0.5*px*self.constant;
    rany = arc4random() % self.yConstant;
    rany += 0.5*py*self.yConstant;
    for(int someInt = 0;[self checkNestOverlap:CGPointMake(ranx, rany)]; ranx ++){
        someInt ++;
        NSLog(@"sprite moved %i pixels to avoid overlap", someInt);
    }
    int shouldGenerate = arc4random() % 1000;
    if(shouldGenerate <= 20){
        if(abs(ranx - hero.position.x) >= 50 || abs(rany - hero.position.y) >= 50){
            [self createNestAtPos:CGPointMake(ranx, rany) withRed:NO];
        }
//        NSLog(@"NEW NEST");
    } else if(shouldGenerate <= 60){
        [self createPointAtPos:CGPointMake(ranx,rany)];
    }
}

#pragma mark - Game Over

-(void)gameOver{
//    if([self.owner respondsToSelector:@selector(gameOverCalled)]){
        [self.owner gameOverCalled];
    [self runAction:[SKAction playSoundFileNamed:@"dead.wav" waitForCompletion:NO]];
//    }
}

#pragma mark - Create Nest

-(void)createNestAtPos:(CGPoint)nestPos withRed:(BOOL)red{
    SKNestSprite *nest = [SKNestSprite spriteNodeWithImageNamed:@"nestStatic@2x.png"];
    if(red){
        [nest setTexture:[SKTexture textureWithImageNamed:@"nestStaticR@2x.png"]];
    }
    [nest setPosition:nestPos];
    float ranTheta = arc4random() % 6282;
    ranTheta /= 1000;
    ranTheta -= M_PI;
    [nest setZRotation:ranTheta];
    nest.constant = self.constant/1.5;
    nest.number = 0;
    [nest setSize:CGSizeMake(0, 0)];
    [self addChild:nest];
    for(int suttin = 0; nest.size.height <= self.constant/6; suttin ++){
        [nest runAction:[SKAction rotateByAngle:0.1 duration:2]];
        [nest setSize:CGSizeMake(nest.size.width + 1, nest.size.height + 1)];
    }
    nest.isRed = red;
    [nest spawnRandom];
    [self runAction:[SKAction playSoundFileNamed:@"spawn.wav" waitForCompletion:NO]];
}

#pragma mark - Create Point

-(void)createPointAtPos:(CGPoint)pointPos{
    SKPointSprite *point = [SKPointSprite spriteNodeWithImageNamed:@"point@2x.png"];
    [point setPosition:CGPointMake(pointPos.x, pointPos.y)];
    [point setSize:CGSizeMake(self.constant/30, self.constant/30)];
    /*float ranTheta = arc4random() % 628;
    ranTheta /= 100;
    ranTheta -= M_PI;
    [point setZRotation:ranTheta];*/
    [self addChild:point];
}

#pragma mark - Initiate Game

-(void)initiateGame{
    [self runAction:[SKAction repeatActionForever:[SKAction playSoundFileNamed:@"loop.wav" waitForCompletion:YES]]];
    //    NSLog(@"New Game");
    for(SKSpriteNode *node in self.children){
        [node removeFromParent];
//        [node dealloc];
    }
    self.isTeleporting = false;
    tdx = 0;
    tdy = 0;
    self.noOfTeleports = 5;
    x = 0;
    y = 0;
    dx = 0;
    dy = 0;
    px = 0;
    py = 0;
    hyp = 0;
    prevScore = self.score;
//    if(prevScore && prevScore != 0){
////        NSLog(@"%i", prevScore);
//        [self loadShareBanner];
//    }
    self.score = 0;
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.highScore = [self.defaults integerForKey:@"High Score"];
    hero = [SKSpriteNode spriteNodeWithImageNamed:@"hero.png"];
    [hero setSize:CGSizeMake(self.constant/8 * 1.18, self.constant/8)];
    touchPoint = CGPointMake(self.constant/2, self.yConstant/2);
    [hero setPosition:touchPoint];
    [self addChild:hero];
//  ADD SCORE LABEL
    self.myLabel = [SKLabelNode labelNodeWithFontNamed:@"Dense-Regular"];
    self.myLabel.text = [NSString stringWithFormat:@"%i", self.score];
    self.myLabel.fontSize = 27;
    [self.myLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
    CGPoint point = CGPointMake(self.constant - 10, yConstant - 28);
    self.myLabel.position = point;
    [self.myLabel setZPosition:1000];
    [self.myLabel setFontColor:[UIColor whiteColor]];
    [self addChild:self.myLabel];
//  ADD 'SCORE' TEXT LABEL
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Dense-Regular"];
    scoreLabel.text = @"SCORE:";
    scoreLabel.fontSize = 27;
    [scoreLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
    CGPoint scorePoint = CGPointMake(self.constant - 100, yConstant - 28);
    scoreLabel.position = scorePoint;
    [scoreLabel setZPosition:1000];
    [scoreLabel setFontColor:[UIColor whiteColor]];
    [self addChild:scoreLabel];
//  ADD TELEPORTS LABEL
    self.teleports = [SKLabelNode labelNodeWithFontNamed:@"Dense-Regular"];
    self.teleports.text = [NSString stringWithFormat:@"TELEPORTS: %i", self.noOfTeleports];
    [self.teleports setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
    self.teleports.fontSize = 27;
    CGPoint telePoint = CGPointMake(37, yConstant - 28);
    self.teleports.position = telePoint;
    [self.teleports setFontColor:[UIColor whiteColor]];
    [self.teleports setZPosition:1000];
    [self addChild:self.teleports];
//  ADD NAV BAR
    SKSpriteNode *navBar = [SKSpriteNode spriteNodeWithImageNamed:@"bar.png"];
    navBar.position = CGPointMake(constant/2, yConstant - 37);
    [navBar setZPosition:1000];
    [self addChild:navBar];
    int rannum = arc4random() % 5;
    rannum ++;
    for(int xy = 0; xy < rannum; xy ++){
        ranx = arc4random() % self.constant;
        rany = arc4random() % self.yConstant;
        for(int someInt = 0;[self checkNestOverlap:CGPointMake(ranx, rany)]; ranx ++){
            someInt ++;
            NSLog(@"sprite moved %i pixels to avoid overlap", someInt);
        }
        if(abs(ranx - hero.position.x) >= 100 || abs(rany - hero.position.y) >= 100){
            [self createNestAtPos:CGPointMake(ranx, rany) withRed:NO];
        } else{
            xy --;
        }
    }
    // add static background
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"bgStatic.jpg"];
    bg.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [bg setZPosition:-10];
    [self addChild:bg];
    texturesTeleportIn = [[NSMutableArray alloc]init];
    for(int textureInt = 1; textureInt < 9; textureInt ++){
        [texturesTeleportIn addObject:[self.heroTeleportTextures textureNamed:[NSString stringWithFormat:@"heroTeleport%i.png", 9 - textureInt]]];
    }
    [texturesTeleportIn addObject:[SKTexture textureWithImageNamed:@"hero.png"]];
    SKAction *animateTeleportIn = [SKAction animateWithTextures:texturesTeleportIn timePerFrame:0.05];
    [hero runAction:animateTeleportIn completion:^(){
        self.isPaused = NO;
    }];
}

-(void)loadShareBanner{
        
}

-(void)pause{
        if(!self.isPaused){
            self.isPaused = YES;
        } else{
            self.isPaused = NO;
        }
}

-(int)returnHighScore{
    return self.highScore;
}
@end
