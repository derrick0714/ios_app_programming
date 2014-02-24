//
//  MyScene.m
//  dragon
//
//  Created by Xu Deng on 2/23/14.
//  Copyright (c) 2014 Xu Deng. All rights reserved.
//

#import "MyScene.h"

@interface MyScene()
@property SKSpriteNode* dragonHead;
@property SKSpriteNode* headOfDragonSquareBody;
@property SKNode *layerBackgroundNode;
@property NSTimeInterval timeLastUpdated;
@end

@implementation MyScene


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.scaleMode = SKSceneScaleModeAspectFit;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        [self.physicsBody setRestitution:1];

        [self setupBgSceneLayers];
        [self setupDragon];

    }
    return self;
}

//setup background
- (void)setupBgSceneLayers {
    _layerBackgroundNode = [SKNode node];
    
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *spaceDust =
        [SKSpriteNode spriteNodeWithImageNamed:@"bg.jpg"];
        spaceDust.anchorPoint = CGPointZero;
        spaceDust.position = CGPointMake(0, i * spaceDust.size.height);
        spaceDust.name = @"bgSpaceDust";
        
        // add flame
        [spaceDust addChild:[self appendFlame: self.size.width/2 posY:self.size.height/0.9]];
        [spaceDust addChild:[self appendFlame: self.size.width/1.2 posY:self.size.height/0.8]];
        [spaceDust addChild:[self appendFlame: self.size.width/4 posY:self.size.height/1.2]];
        [spaceDust addChild:[self appendFlame: self.size.width/2.4 posY:self.size.height/1.4]];

        [_layerBackgroundNode addChild:spaceDust];
    }
    
    [self addChild:_layerBackgroundNode];
    
}

//append a flame
- (SKSpriteNode*) appendFlame:(CGFloat) posX posY:(CGFloat) posY{
    
    SKSpriteNode* myShelf =[SKSpriteNode spriteNodeWithImageNamed:@"flame"];
    myShelf.position = CGPointMake(posX, posY);
    myShelf.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:45.0f];
    [myShelf.physicsBody setDynamic:NO];
    [myShelf setXScale: 0.3];
    [myShelf setYScale: 0.3];
    myShelf.physicsBody.categoryBitMask = CollisionTypeFlame;
    myShelf.physicsBody.collisionBitMask = 0;
    myShelf.physicsBody.contactTestBitMask = CollisionTypeDragon;
    
    return myShelf;
}

//setup dargon head
- (void)setupDragonHead {
    _dragonHead = [SKSpriteNode spriteNodeWithImageNamed:@"dragon-head"];
    _dragonHead.position = CGPointMake(self.size.width/6, self.size.height/1.5);
    _dragonHead.name = @"dragon-head";
    
    //resize the picture
    [_dragonHead setXScale: 0.6];
    [_dragonHead setYScale: 0.6];
    
    //configureCollisionBody
    _dragonHead.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_dragonHead.size];
    [_dragonHead.physicsBody setRestitution:1.0];
    [_dragonHead.physicsBody setAllowsRotation:FALSE];
    _dragonHead.physicsBody.categoryBitMask = CollisionTypeDragon;
    _dragonHead.physicsBody.collisionBitMask = CollisionTypeFlame;
    _dragonHead.physicsBody.contactTestBitMask = CollisionTypeFlame;

    
    [self addChild:_dragonHead];

}

//create dragon body with SKPhysicsJointLimit
- (SKSpriteNode*) setupDragonSquareBody:(int) number{
    SKSpriteNode* mySquarebody1, *mySquarebody2;
    SKPhysicsJoint* myRopeJoint;
    
    for(int i = 0 ; i< number; i++ ){
        //add a new pice of body
        mySquarebody1 = [[SKSpriteNode alloc]initWithColor:[SKColor greenColor] size:CGSizeMake(25, 25)];
        [mySquarebody1 setPosition:CGPointMake(_dragonHead.position.x+30*(i+1), _dragonHead.position.y)];
        mySquarebody1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:mySquarebody1.size];
        [mySquarebody1.physicsBody setRestitution:1.0];
        [self addChild:mySquarebody1];
        
        //make two pices of body connect together
        if(i == 0){
            _headOfDragonSquareBody =mySquarebody1;
        }
        else{
            //add a join
            myRopeJoint = [SKPhysicsJointLimit jointWithBodyA:mySquarebody1.physicsBody bodyB:mySquarebody2.physicsBody anchorA:mySquarebody1.position anchorB:mySquarebody2.position];
        
            [self.physicsWorld addJoint:myRopeJoint];
        }
        
        mySquarebody2 = mySquarebody1;
    }
    
    
    return _headOfDragonSquareBody;
}


//setup dragon inclding head and body with SKPhysicsJointSpring
- (void)setupDragon {
    [self setupDragonHead];
    SKSpriteNode* headOfDragonSquareBody = [self setupDragonSquareBody:8];
    
    //connect head and body with SKPhysicsJointSpring
     SKPhysicsJoint* myRopeJoint = [SKPhysicsJointSpring jointWithBodyA:_dragonHead.physicsBody bodyB:headOfDragonSquareBody.physicsBody anchorA: _dragonHead.position anchorB:headOfDragonSquareBody.position];
    
    [self.physicsWorld addJoint:myRopeJoint];
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if (_dragonHead.physicsBody.dynamic) {
        // asserted when collision happened
        _dragonHead.physicsBody.dynamic = NO;
        
    }
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [_dragonHead setPosition:location];
        
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [_dragonHead setPosition:location];
        
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event  {
    
    if (!_dragonHead.physicsBody.dynamic) {
        _dragonHead.physicsBody.dynamic = YES;
        
        
    }

}

//make backgroud move
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    CFTimeInterval timeInterval =0;
    if(_timeLastUpdated)
        timeInterval = (currentTime - _timeLastUpdated);
    
    _timeLastUpdated = currentTime;
    
    CGPoint velocity = CGPointMake(0, -65);
    CGPoint valueToMove = CGPointMake(velocity.x * timeInterval, velocity.y * timeInterval);
    _layerBackgroundNode.position = CGPointMake(_layerBackgroundNode.position.x + valueToMove.x,
                                           _layerBackgroundNode.position.y + valueToMove.y);
    
    
    [_layerBackgroundNode enumerateChildNodesWithName:@"bgSpaceDust"
                                      usingBlock:^(SKNode *node, BOOL *stop){
                                          SKSpriteNode * bg = (SKSpriteNode *) node;
                                          CGPoint screenPosition = [_layerBackgroundNode convertPoint:bg.position toNode:self];
                                          if (screenPosition.y <= -bg.size.height) {
                                              bg.position = CGPointMake(bg.position.x,
                                                                        bg.position.y + bg.size.height * 2);
                                          }
                                      }];
}

@end
