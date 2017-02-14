//
//  MushroomNode.m
//  Champipong
//
//  Created by David on 25/10/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "MushroomNode.h"
#import "CollisionMask.h"

@implementation MushroomNode

-(instancetype)init {
    if(self = [self initWithImageNamed:@"mushroom"]){
        self.size = [MushroomNode size];
        self.name = @"mushroom";
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = CollisionCategoryMushroom;
        self.physicsBody.contactTestBitMask = CollisionCategoryPlayerBread;
        self.physicsBody.collisionBitMask = CollisionCategoryPlayerBread | CollisionCategoryMushroomClip | CollisionCategoryPrawn |CollisionCategoryPrawnClip;
        self.physicsBody.affectedByGravity = YES;
        self.physicsBody.dynamic = YES;
        self.zPosition = 5;
    }
    
    return self;
}

+(CGSize)size {
    return CGSizeMake(35, 28);
}

@end
