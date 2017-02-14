//
//  BreadNode.m
//  Champipong
//
//  Created by David on 25/10/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "BreadNode.h"
#import "MushroomNode.h"
#import "PrawnNode.h"
#import "CollisionMask.h"

@interface BreadNode()

@property (nonatomic, strong) PrawnNode *prawn;
@property (nonatomic, strong) NSMutableArray *mushrooms;
@property (nonatomic, strong) SKSpriteNode *background;

@end

@implementation BreadNode

-(instancetype)init {
    if(self = [super init]){
        self.name = @"bread";
        self.size = CGSizeMake(70, 131);
        self.background = [[SKSpriteNode alloc] initWithImageNamed:@"bread"];
        self.background.size = CGSizeMake(70, 131);
        self.background.position = self.centerRect.origin;
        self.background.zPosition = 50;
        self.mushrooms = [NSMutableArray array];
        
        CGFloat offsetX = self.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.size.height * self.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 31 - offsetX, 62 - offsetY);
        CGPathAddLineToPoint(path, NULL, 31 - offsetX, 97 - offsetY);
        CGPathAddLineToPoint(path, NULL, 31 - offsetX, 107 - offsetY);
        CGPathAddLineToPoint(path, NULL, 33 - offsetX, 130 - offsetY);
        CGPathAddLineToPoint(path, NULL, 34 - offsetX, 131 - offsetY);
        CGPathAddLineToPoint(path, NULL, 36 - offsetX, 110 - offsetY);
        CGPathAddLineToPoint(path, NULL, 36 - offsetX, 67 - offsetY);
        CGPathAddLineToPoint(path, NULL, 44 - offsetX, 74 - offsetY);
        CGPathAddLineToPoint(path, NULL, 49 - offsetX, 75 - offsetY);
        CGPathAddLineToPoint(path, NULL, 58 - offsetX, 74 - offsetY);
        CGPathAddLineToPoint(path, NULL, 65 - offsetX, 68 - offsetY);
        CGPathAddLineToPoint(path, NULL, 68 - offsetX, 60 - offsetY);
        CGPathAddLineToPoint(path, NULL, 69 - offsetX, 49 - offsetY);
        CGPathAddLineToPoint(path, NULL, 66 - offsetX, 42 - offsetY);
        CGPathAddLineToPoint(path, NULL, 31 - offsetX, 6 - offsetY);
        CGPathAddLineToPoint(path, NULL, 25 - offsetX, 2 - offsetY);
        CGPathAddLineToPoint(path, NULL, 20 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, NULL, 13 - offsetX, 2 - offsetY);
        CGPathAddLineToPoint(path, NULL, 5 - offsetX, 8 - offsetY);
        CGPathAddLineToPoint(path, NULL, 1 - offsetX, 16 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 29 - offsetY);
        
        CGPathCloseSubpath(path);
        
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        self.physicsBody.categoryBitMask = CollisionCategoryPlayerBread;
        self.physicsBody.collisionBitMask = CollisionCategoryMushroom | CollisionCategoryPrawn;
        self.physicsBody.contactTestBitMask = CollisionCategoryMushroom | CollisionCategoryPrawn;
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.dynamic = NO;
        self.physicsBody.usesPreciseCollisionDetection = YES;
        self.zPosition = 10;
        
        [self addChild:self.background];
    }
    
    return self;
}

-(BOOL)isComplete {
    return self.mushrooms.count == 3 && self.prawn;
}

-(BOOL)acceptPrawn {
    return !self.prawn && self.mushrooms.count <= 3;
}

-(BOOL)acceptMoreMushrooms {
    return self.mushrooms.count <= 3 && !self.prawn;
}

-(void)emptyBread {
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    SKAction *sequence = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.25], [SKAction removeFromParent]]];
    
    if(self.prawn){
        dispatch_group_enter(serviceGroup);
        [self.prawn runAction:sequence completion:^{
            dispatch_group_leave(serviceGroup);
        }];
    }
    
    for (MushroomNode *node in self.mushrooms) {
        dispatch_group_enter(serviceGroup);
        [node runAction:sequence completion:^{
            dispatch_group_leave(serviceGroup);
        }];
    }
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(),^{
        self.prawn = nil;
        [self.mushrooms removeAllObjects];
        NSLog(@"Pan limpiado");
    });
}

-(void)addMushroomCompletionBlock:(void (^)())completionBlock {
    
    MushroomNode *mushroom = [[MushroomNode alloc] init];
    mushroom.position = CGPointMake(self.centerRect.origin.x, self.centerRect.origin.y + (self.size.height/2));
    mushroom.zPosition = 100;
    mushroom.physicsBody.categoryBitMask = CollisionCategoryMushroomClip;
    mushroom.physicsBody.collisionBitMask = CollisionCategoryMushroom | CollisionCategoryPrawn;
    mushroom.physicsBody.affectedByGravity = NO;
    mushroom.physicsBody.dynamic = NO;
    
    [self.mushrooms addObject:mushroom];
    NSLog(@"Añadido champiñon");
    
    [self addChild:mushroom];
    
    SKAction *actionMove = [SKAction moveTo:CGPointMake(mushroom.position.x, -15 + ((self.mushrooms.count-1) * (mushroom.size.height * 0.8))) duration:1-(0.25 * (self.mushrooms.count-1))];
    //SKAction *actionMoveDone = [SKAction removeFromParent];
    [mushroom runAction:[SKAction sequence:@[actionMove]] completion:^{
        if(self.mushrooms.count > 3){
            [self emptyBread];
        }
        
        if(completionBlock){
            completionBlock();
        }
    }];
}

-(void)addPrawnWithCompletionBlock:(void (^)())completionBlock {
    
    PrawnNode *prawn = [[PrawnNode alloc] init];
    prawn.position = CGPointMake(self.centerRect.origin.x, self.centerRect.origin.y + (self.size.height/2));
    prawn.zPosition = 101;
    prawn.physicsBody.categoryBitMask = CollisionCategoryPrawnClip;
    prawn.physicsBody.collisionBitMask = CollisionCategoryMushroom | CollisionCategoryPrawn;
    prawn.physicsBody.affectedByGravity = NO;
    prawn.physicsBody.dynamic = NO;
    
    self.prawn = prawn;
    NSLog(@"Añadida gamba");
    
    [self addChild:prawn];
    
    SKAction *actionMove = [SKAction moveTo:CGPointMake(prawn.position.x, -15 + ((self.mushrooms.count) * ([MushroomNode size].height * 0.8))) duration:1-(0.25 * (self.mushrooms.count))];
    
    [prawn runAction:[SKAction sequence:@[actionMove]] completion:^{
        
        [self emptyBread];
        
        if(self.isComplete){
            if(completionBlock){
                completionBlock();
            }
        }
    }];
    
    
}

@end
