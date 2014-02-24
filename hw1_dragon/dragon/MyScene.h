//
//  MyScene.h
//  dragon
//

//  Copyright (c) 2014 Xu Deng. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_OPTIONS(uint32_t, CollisionType) {
    CollisionTypeDragon      =1 << 0,
    CollisionTypeFlame      =1 << 1,
};

@interface MyScene : SKScene


@end
