//
//  EggScene.h
//  smartcity
//
//  Created by David on 27/9/16.
//  Copyright © 2016 jgurria. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface EggScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, strong) SKSpriteNode *bread;

@property (nonatomic, strong) SKShapeNode *pauseButton;
@property (nonatomic, strong) SKShapeNode *continueButton;
@property (nonatomic, strong) SKShapeNode *exitButton;
@property (nonatomic, strong) SKShapeNode *pauseMenu;

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@end
