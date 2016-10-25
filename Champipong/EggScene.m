//
//  EggScene.m
//  smartcity
//
//  Created by David on 27/9/16.
//  Copyright © 2016 jgurria. All rights reserved.
//

#import "EggScene.h"

static NSString * const kBreadNodeName = @"movable";

typedef NS_OPTIONS(NSUInteger, CollisionCategory)
{
    CollisionCategoryChampi = 0,
    CollisionCategoryPlayerBread = 1 << 0,
    CollisionCategoryGamba = 1 << 1,
};

@implementation EggScene{
    BOOL moving;
}

-(void)createScene {
    //Inicializacion
    self.backgroundColor = [SKColor darkGrayColor];
    self.physicsWorld.gravity = CGVectorMake(0, -2);
    
    //Jugador
    self.bread = [[SKSpriteNode alloc] initWithImageNamed:@"bread"];
    self.bread.size = CGSizeMake(70, 104);
    self.bread.position = CGPointMake(self.size.width/2, (self.bread.size.height/2)+30);
    
    CGFloat offsetX = self.bread.frame.size.width * self.bread.anchorPoint.x;
    CGFloat offsetY = self.bread.frame.size.height * self.bread.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 35 - offsetX, 103 - offsetY);
    CGPathAddLineToPoint(path, NULL, 31 - offsetX, 24 - offsetY);
    CGPathAddLineToPoint(path, NULL, 2 - offsetX, 22 - offsetY);
    CGPathAddLineToPoint(path, NULL, 1 - offsetX, 1 - offsetY);
    CGPathAddLineToPoint(path, NULL, 68 - offsetX, 1 - offsetY);
    CGPathAddLineToPoint(path, NULL, 68 - offsetX, 22 - offsetY);
    CGPathAddLineToPoint(path, NULL, 40 - offsetX, 24 - offsetY);
    
    CGPathCloseSubpath(path);
    
    self.bread.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    self.bread.physicsBody.categoryBitMask = CollisionCategoryPlayerBread;
    self.bread.physicsBody.collisionBitMask = CollisionCategoryChampi;
    self.bread.physicsBody.contactTestBitMask = CollisionCategoryChampi;
    self.bread.physicsBody.affectedByGravity = NO;
    self.bread.physicsBody.dynamic = YES;
    self.bread.physicsBody.usesPreciseCollisionDetection = YES;
    self.bread.zPosition = 10;
    
    [self addChild:self.bread];
    
    moving = NO;
    
    //Boton de pausa
    self.pauseButton = [self getLabelWithText:@"⏸" andFontSize:40 andFontColor:[SKColor whiteColor] andFont:@"" andBackgroundColor:[SKColor clearColor] andSize:CGSizeMake(40, 40) andName:@"pauseButton"];
    self.pauseButton.position = CGPointMake(self.pauseButton.frame.size.width/2 + 5, self.size.height - self.pauseButton.frame.size.height/2 - 5);
    self.pauseButton.zPosition = 99;
    
    [self addChild:self.pauseButton];
    
    //Menu
    self.pauseMenu = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.size.width, self.size.height)];
    self.pauseMenu.strokeColor = self.pauseMenu.fillColor = [[SKColor blackColor] colorWithAlphaComponent:0.6];
    self.pauseMenu.position = CGPointMake(self.size.width/2, self.size.height/2);
    self.pauseMenu.zPosition = 100;
    self.pauseMenu.name = @"pauseMenu";
    
    self.continueButton = [self getLabelWithText:@"Continuar" andFontSize:26 andFontColor:[SKColor blackColor] andFont:@"" andBackgroundColor:[SKColor whiteColor] andSize:CGSizeMake(self.size.width*2/3, 40) andName:@"continueButton"];
    self.continueButton.position = CGPointMake(0, 25);
    [self.pauseMenu addChild:self.continueButton];
    
    self.exitButton = [self getLabelWithText:@"Salir" andFontSize:26 andFontColor:[SKColor blackColor] andFont:@"" andBackgroundColor:[SKColor whiteColor] andSize:CGSizeMake(self.size.width*2/3, 40) andName:@"exitButton"];
    self.exitButton.position = CGPointMake(0, -25);
    [self.pauseMenu addChild:self.exitButton];
    
}

-(SKShapeNode *)getLabelWithText:(NSString *)text andFontSize:(CGFloat)fontSize andFontColor:(SKColor *)fontColor andFont:(NSString *)font andBackgroundColor:(SKColor *) color andSize:(CGSize)size andName:(NSString *)name{
    SKLabelNode *label = [[SKLabelNode alloc] initWithFontNamed:font];
    label.text = text;
    label.fontSize = fontSize;
    label.name = @"labelButton";
    label.fontColor = fontColor;
    label.zPosition = 1;
    
    SKShapeNode* background = [SKShapeNode node];
    [background setPath:CGPathCreateWithRoundedRect(CGRectMake(-size.width/2, -size.height/2, size.width, size.height), 4, 4, nil)];
    background.strokeColor = background.fillColor = color;
    background.zPosition = 0;
    [background addChild:label];
    label.position = CGPointMake(0, -label.frame.size.height/2);
    
    SKShapeNode *button = [SKShapeNode node];
    [button setPath:CGPathCreateWithRoundedRect(CGRectMake(-size.width/2, -size.height/2, size.width, size.height), 0, 0, nil)];
    button.strokeColor = button.fillColor = [SKColor clearColor];
    button.zPosition = 2;
    button.name = name;
    button.position = CGPointMake(0, 0);
    [background addChild:button];
    
    return background;
}

- (void)addChampi {
    
    // Create sprite
    SKSpriteNode *champi = [SKSpriteNode spriteNodeWithImageNamed:@"location_red"];
    champi.name = @"champi";
    champi.size = CGSizeMake(60, 20);
    
    // Determine where to spawn the champi along the Y axis
    int minX = champi.size.width / 2;
    int maxX = self.frame.size.width - champi.size.width / 2;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    
    champi.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:champi.size]; // 1
    champi.physicsBody.dynamic = YES; // 2
    champi.physicsBody.categoryBitMask = CollisionCategoryChampi; // 3
    champi.physicsBody.contactTestBitMask = CollisionCategoryPlayerBread; // 4
    champi.physicsBody.collisionBitMask = CollisionCategoryPlayerBread;
    champi.physicsBody.affectedByGravity = YES;
    champi.physicsBody.dynamic = YES;
    champi.zPosition = 5;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    champi.position = CGPointMake(actualX, self.frame.size.height + champi.size.height/2);
    [self addChild:champi];
    
    // Determine speed of the champi
    /*int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX, -champi.size.height/2) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [champi runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];*/
    
}

-(void)tooglePause{
    if(self.paused){
        [self.pauseMenu removeFromParent];
    }
    else{
        [self addChild:self.pauseMenu];
    }
    
    self.paused = !self.paused;
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        [self addChampi];
    }
}

- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
    [self enumerateChildNodesWithName:@"champi" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x < 0){
            [node removeFromParent];
        }
    }];
    
}

-(void)didMoveToView:(SKView *)view {
    [self createScene];
}

#pragma mark - Touch

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    SKNode *touchedNode = [self nodeAtPoint:positionInScene];
    
    if([touchedNode isEqualToNode:self.bread]){
        moving = YES;
    }
    else if([touchedNode.name isEqualToString:@"pauseButton"]){
        [self tooglePause];
    }
    else if([touchedNode.name isEqualToString:@"continueButton"]){
        [self tooglePause];
    }
    else if([touchedNode.name isEqualToString:@"exitButton"]){
        [self.controller dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint positionInScene = [touch locationInNode:self];
	CGPoint previousPosition = [touch previousLocationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:positionInScene];

    if([touchedNode isEqualToNode:self.bread]){
        CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
        
        [self panForTranslation:translation];
    }
}

- (void)panForTranslation:(CGPoint)translation {
    CGPoint position = [self.bread position];
    
    int minX = self.bread.size.width / 2;
    int maxX = self.frame.size.width - self.bread.size.width / 2;
    
    CGFloat futureX = position.x + translation.x;
    
    if(futureX < minX){
        futureX = minX;
    }
    
    if(futureX > maxX){
        futureX = maxX;
    }
    
    [self.bread setPosition:CGPointMake(futureX, position.y)];
}


@end
