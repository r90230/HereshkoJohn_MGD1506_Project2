//
//  Platform.m
//  hereshkoJohn_MGD1506_Project1
//
//  Created by John Hereshko on 6/11/15.
//  Copyright (c) 2015 John Hereshko. All rights reserved.
//

#import "Platform.h"

@implementation Platform

-(id)init
{
    if (self = [super init]) {
        jumpSound = [SKAction playSoundFileNamed:@"jump.m4a" waitForCompletion:NO];
    }
    return self;
};

-(BOOL) collisionWithPlayer:(SKNode *)player
{
    if (player.physicsBody.velocity.dy < 0) {
        player.physicsBody.velocity = CGVectorMake(player.physicsBody.velocity.dx, 850.0f);
    }
    
    [self.parent runAction:jumpSound];
    
    if (self.platformType == PLATFORM_BREAK) {
        [self removeFromParent];
    }
    
    return NO;
};

@end
