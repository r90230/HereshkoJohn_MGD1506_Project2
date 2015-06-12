//
//  Boost.m
//  hereshkoJohn_MGD1506_Project1
//
//  Created by John Hereshko on 6/11/15.
//  Copyright (c) 2015 John Hereshko. All rights reserved.
//

#import "Boost.h"

@implementation Boost

-(id)init
{
    if (self = [super init]) {
        boostSound = [SKAction playSoundFileNamed:@"Boost.m4a" waitForCompletion:NO];
    }
    return self;
};

-(BOOL) collisionWithPlayer:(SKNode *)player
{
    player.physicsBody.velocity = CGVectorMake(player.physicsBody.velocity.dx, 1150.0f);
    
    [self.parent runAction:boostSound];
    
    [self removeFromParent];
    
    return YES;
};

@end
