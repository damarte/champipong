//
//  EggScene.h
//  smartcity
//
//  Created by David on 27/9/16.
//  Copyright © 2016 jgurria. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class BreadNode;

@interface EggScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, strong) BreadNode *bread;

@property (nonatomic, strong) SKShapeNode *pauseButton;
@property (nonatomic, strong) SKShapeNode *continueButton;
@property (nonatomic, strong) SKShapeNode *exitButton;
@property (nonatomic, strong) SKShapeNode *pauseMenu;

@property (nonatomic) NSTimeInterval lastSpawnMushroomTimeInterval;

@property (nonatomic) NSTimeInterval lastSpawnPrawnTimeInterval;

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@end
