//
//  BreadNode.h
//  Champipong
//
//  Created by David on 25/10/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BreadNode : SKSpriteNode

-(void)addMushroomCompletionBlock:(void (^)())completionBlock;
-(void)addPrawnWithCompletionBlock:(void (^)())completionBlock;

-(BOOL)acceptPrawn;
-(BOOL)acceptMoreMushrooms;
-(BOOL)isComplete;

@end
