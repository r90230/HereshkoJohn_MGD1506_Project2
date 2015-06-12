//
//  GameScene.h
//  hereshkoJohn_MGD1506_Project1
//

//  Copyright (c) 2015 John Hereshko. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>
{
    SKSpriteNode *mainSprite;
    SKSpriteNode *tapToStart;
    SKNode *midGround;
    SKNode *backgroundNode;
}

@property (nonatomic,assign) BOOL movingRight;
@property (nonatomic,assign) BOOL movingLeft;
@property (nonatomic,assign) BOOL gameStarted;


@end
