//
//  Platform.h
//  hereshkoJohn_MGD1506_Project1
//
//  Created by John Hereshko on 6/11/15.
//  Copyright (c) 2015 John Hereshko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObjectNode.h"

typedef NS_ENUM(int, PlatformType) {
  PLATFORM_NORMAL,
    PLATFORM_BREAK,
};

@interface Platform : GameObjectNode
{
    SKAction *jumpSound;
}

@property (nonatomic, assign) PlatformType platformType;

@end
