//
//  SKNestSprite.m
//  OutlastDotGame
//
//  Created by Eric Mcallister on 30/04/2014.
//  Copyright (c) 2014 ERIC. All rights reserved.
//

#import "SKNestSprite.h"

@implementation SKNestSprite
@synthesize constant, number;
@synthesize isRed;
-(void)spawnRandom{
    self.number ++;
    SKEnemySprite *newEnemy = [SKEnemySprite spriteNodeWithImageNamed:@"baddie1.png"];
    if(self.isRed){
        [newEnemy setTexture:[SKTexture textureWithImageNamed:@"baddieR1@2x.png"]];
    }
    [newEnemy setSize:CGSizeMake(6*self.constant/40, 6*self.constant/40)];
    [newEnemy setPosition:self.position];
    newEnemy.isDead = NO;
    newEnemy.isRed = self.isRed;
    newEnemy.esize = 1;
    [newEnemy setZPosition:1];
    newEnemy.constant = self.constant;
    int shouldBeRed = arc4random() % 6;
    if(shouldBeRed == 1){
        [newEnemy makeRed];
    }
    [self.parent addChild:newEnemy];
}
@end
