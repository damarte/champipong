//
//  PrawnNode.m
//  Champipong
//
//  Created by David on 27/10/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PrawnNode.h"
#import "CollisionMask.h"

@implementation PrawnNode

-(instancetype)init {
    if(self = [self initWithImageNamed:@"prawn"]){
        self.size = CGSizeMake(24, 21);
        self.name = @"prawn";
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = CollisionCategoryPrawn;
        self.physicsBody.contactTestBitMask = CollisionCategoryPlayerBread;
        self.physicsBody.collisionBitMask = CollisionCategoryPlayerBread | CollisionCategoryMushroomClip | CollisionCategoryMushroom | CollisionCategoryPrawnClip;
        self.physicsBody.affectedByGravity = YES;
        self.physicsBody.dynamic = YES;
        self.zPosition = 4;
    }
    
    return self;
}

@end
