//
//  GameScene.m
//  hereshkoJohn_MGD1506_Project1
//
//  Created by John Hereshko on 6/6/15.
//  Copyright (c) 2015 John Hereshko. All rights reserved.
//

#import "GameScene.h"
#import "GameObjectNode.h"
#import "Platform.h"
#import "Boost.h"

typedef NS_OPTIONS(uint32_t, CollisionCategory){
    CollisionCategoryPlayer = 0x1 << 0,
    CollisionCategoryStar = 0x1 << 1,
    CollisionCategoryPlatform = 0x1 << 2,
};

@implementation GameScene

- (id) initWithSize:(CGSize)size
{
    self.userInteractionEnabled = YES;
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0.0f, -2.0f);
        self.physicsWorld.contactDelegate = self;

    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.physicsWorld.contactDelegate = self;
    
    backgroundNode = [SKNode node];
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"minpre"];
    background.anchorPoint = CGPointZero;
    background.position = CGPointMake(0,0);
    background.xScale = 5;
    background.yScale = 5;
    
    SKSpriteNode *background2 = [SKSpriteNode spriteNodeWithImageNamed:@"minpre2"];
    background2.anchorPoint = CGPointZero;
    background2.position = CGPointMake(0,background.size.height-1);
    background2.xScale = 5;
    background2.yScale = 5;
    
    SKSpriteNode *background3 = [SKSpriteNode spriteNodeWithImageNamed:@"minpre"];
    background3.anchorPoint = CGPointZero;
    background3.position = CGPointMake(0,background2.size.height-1);
    background3.xScale = 5;
    background3.yScale = 5;
    
    SKSpriteNode *background4 = [SKSpriteNode spriteNodeWithImageNamed:@"minpre2"];
    background4.anchorPoint = CGPointZero;
    background4.position = CGPointMake(0,background3.size.height-1);
    background4.xScale = 5;
    background4.yScale = 5;
    
    [backgroundNode addChild:background];
    [backgroundNode addChild:background2];
    [backgroundNode addChild:background3];
    [backgroundNode addChild:background4];
    
    SKNode *camera = [SKNode node];
    [camera setName:@"camera"];

    
    SKAction *music = [SKAction repeatActionForever:[SKAction playSoundFileNamed:@"Background.mp3" waitForCompletion:YES]];
    [self runAction:music];
    
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    mainSprite = [SKSpriteNode spriteNodeWithImageNamed:@"jump2"];
    mainSprite.xScale = 2.6;
    mainSprite.yScale = 2.6;
    mainSprite.position = CGPointMake(CGRectGetMidX(self.frame),
                                      (screenHeight/2)-20);
    [mainSprite setName:@"Player"];
    mainSprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:mainSprite.size.width/2];
    mainSprite.physicsBody.dynamic = NO;
    mainSprite.physicsBody.usesPreciseCollisionDetection = YES;
    mainSprite.physicsBody.categoryBitMask = CollisionCategoryPlayer;
    mainSprite.physicsBody.collisionBitMask = 0;
    mainSprite.physicsBody.contactTestBitMask = CollisionCategoryStar|CollisionCategoryPlatform;
 
    
    
    midGround = [SKNode node];
    [midGround setName:@"midGround"];
    
    int randomValue = arc4random_uniform(500.0f) + 20.0f;
    int randomVertical = arc4random_uniform(500.0f) + 20.0f;

    
    Platform *platform = [self createPlatformAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-160) ofType:PLATFORM_NORMAL];
    Platform *platform2 = [self createPlatformAtPosition:CGPointMake(randomValue, CGRectGetMidY(self.frame)+60) ofType:PLATFORM_NORMAL];
    randomValue = arc4random_uniform(500) + 140;
    Platform *platform3 = [self createPlatformAtPosition:CGPointMake(randomValue, platform2.position.y+120) ofType:PLATFORM_NORMAL];
    randomValue = arc4random_uniform(500) + 140;
    Platform *platform4 = [self createPlatformAtPosition:CGPointMake(randomValue, platform3.position.y+120) ofType:PLATFORM_NORMAL];
    randomValue = arc4random_uniform(500) + 140;
    Platform *platform5 = [self createPlatformAtPosition:CGPointMake(randomValue, platform4.position.y+120) ofType:PLATFORM_NORMAL];
    randomValue = arc4random_uniform(500) + 140;
    Platform *platform6 = [self createPlatformAtPosition:CGPointMake(randomValue, platform5.position.y+120) ofType:PLATFORM_NORMAL];
    
    Boost *boost = [self createBoostAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-100)];
    randomValue = arc4random_uniform(500) + 150;
    Boost *boost2 = [self createBoostAtPosition:CGPointMake(randomValue, randomVertical)];
    randomValue = arc4random_uniform(500) + 150;
    randomVertical = arc4random_uniform(500) + 160;
    Boost *boost3 = [self createBoostAtPosition:CGPointMake(randomValue, randomVertical)];
    
    [midGround addChild:mainSprite];
    [midGround addChild:platform];
    [midGround addChild:platform2];
    [midGround addChild:platform3];
    [midGround addChild:platform4];
    [midGround addChild:platform5];
    [midGround addChild:platform6];
    [midGround addChild:boost];
    [midGround addChild:boost2];
    [midGround addChild:boost3];
    
    tapToStart = [SKSpriteNode spriteNodeWithImageNamed:@"TapToStart"];
    tapToStart.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+150);
    [tapToStart setName:@"tapToStart"];
    
    [self addChild:camera];
    [self addChild:backgroundNode];
    [self addChild:midGround];
    //[self addChild:mainSprite];
    [self addChild:tapToStart];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];

    if (self.gameStarted == NO) {
        if (mainSprite.physicsBody.dynamic) return;
        self.gameStarted = YES;
    };
  
        [tapToStart removeFromParent];
    
        mainSprite.physicsBody.dynamic = YES;
        [mainSprite.physicsBody applyImpulse:CGVectorMake(0.0f, 20.0f)];
    
    CGFloat distance = fabs(location.x - mainSprite.position.x);
    float moveDuration = 0.004*distance;
    SKAction *move = [SKAction moveToX:location.x duration:moveDuration];
    [mainSprite runAction:move];

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (mainSprite.position.y > 250.0f) {
        midGround.position = CGPointMake(0.0f, -((mainSprite.position.y - 250.0f)));
        backgroundNode.position = CGPointMake(0.0f, -((mainSprite.position.y - 250.0f)/10));
    
    }
                                          
    

}


-(Platform*) createPlatformAtPosition:(CGPoint)position ofType:(PlatformType)type
{
    Platform *platform = [Platform node];
    [platform setPosition:position];
    [platform setName:@"PLATFORM"];
    [platform setPlatformType:type];
    
    SKSpriteNode *platformSprite = [SKSpriteNode spriteNodeWithImageNamed:@"platform2"];
    platformSprite.xScale = 3.5;
    platformSprite.yScale = 2;

    [platform addChild:platformSprite];
    
    platform.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:platformSprite.size];
    platform.physicsBody.dynamic = NO;
    platform.physicsBody.categoryBitMask = CollisionCategoryPlatform;
    platform.physicsBody.collisionBitMask = 0;
    
    return platform;

};


-(Boost*) createBoostAtPosition:(CGPoint)position
{
    Boost *boostNode = [Boost node];
    [boostNode setPosition:position];
    [boostNode setName:@"BOOST"];
    
    SKSpriteNode *boostSprite = [SKSpriteNode spriteNodeWithImageNamed:@"books"];
    boostSprite.xScale = .2;
    boostSprite.yScale = .2;
    [boostNode addChild:boostSprite];
    
    boostNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:boostSprite.size.width/2];
    
    boostNode.physicsBody.dynamic = NO;
    boostNode.physicsBody.categoryBitMask = CollisionCategoryStar;
    boostNode.physicsBody.collisionBitMask = 0;
    
    return boostNode;
};

- (void) didBeginContact:(SKPhysicsContact *)contact
{
    // 1
    BOOL updateHUD = NO;
    
    // 2
    SKNode *other = (contact.bodyA.node != mainSprite) ? contact.bodyA.node : contact.bodyB.node;
    
    // 3
    updateHUD = [(GameObjectNode *)other collisionWithPlayer:mainSprite];
    
    // Update the HUD if necessary
    if (updateHUD) {
        // 4 TODO: Update HUD in Part 2
    }
}




@end
