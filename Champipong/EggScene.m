//
//  EggScene.m
//  smartcity
//
//  Created by David on 27/9/16.
//  Copyright © 2016 jgurria. All rights reserved.
//

#import "EggScene.h"
#import "BreadNode.h"
#import "MushroomNode.h"
#import "PrawnNode.h"

static NSString * const kBreadNodeName = @"movable";


@implementation EggScene{
    BOOL moving;
    NSInteger updateCalled;
}

-(void)createScene {
    //Inicializacion
    self.backgroundColor = [SKColor whiteColor];
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0, -2);
    
    //Jugador
    self.bread = [[BreadNode alloc] init];
    self.bread.position = CGPointMake(self.size.width/2, (self.bread.size.height/2)+20);
    
    [self addChild:self.bread];
    
    moving = NO;
    updateCalled = 0;
    
    //Boton de pausa
    self.pauseButton = [self getLabelWithText:@"⏸" andFontSize:40 andFontColor:[SKColor whiteColor] andFont:@"" andBackgroundColor:[SKColor clearColor] andSize:CGSizeMake(40, 40) andName:@"pauseButton"];
    self.pauseButton.position = CGPointMake(self.pauseButton.frame.size.width/2 + 5, self.size.height - self.pauseButton.frame.size.height/2 - 5);
    self.pauseButton.zPosition = 999;
    
    [self addChild:self.pauseButton];
    
    //Menu
    self.pauseMenu = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.size.width, self.size.height)];
    self.pauseMenu.strokeColor = self.pauseMenu.fillColor = [[SKColor blackColor] colorWithAlphaComponent:0.6];
    self.pauseMenu.position = CGPointMake(self.size.width/2, self.size.height/2);
    self.pauseMenu.zPosition = 1000;
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

-(void)addMushroom {
    
    // Create sprite
    MushroomNode *mushroom = [[MushroomNode alloc] init];
    
    // Determine where to spawn the champi along the Y axis
    int minX = mushroom.size.width / 2;
    int maxX = self.frame.size.width - mushroom.size.width / 2;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    mushroom.position = CGPointMake(actualX, self.frame.size.height + mushroom.size.height/2);
    
    [self addChild:mushroom];
    
    NSLog(@"Aparece champiñon");
    
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

- (void)addPrawn {
    
    // Create sprite
    PrawnNode *prawn = [[PrawnNode alloc] init];
    
    // Determine where to spawn the champi along the Y axis
    int minX = prawn.size.width / 2;
    int maxX = self.frame.size.width - prawn.size.width / 2;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    prawn.position = CGPointMake(actualX, self.frame.size.height + prawn.size.height/2);
    
    [self addChild:prawn];
    
    NSLog(@"Aparece gamba");
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

-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnMushroomTimeInterval += timeSinceLast;
    if (self.lastSpawnMushroomTimeInterval > 0.6) {
        self.lastSpawnMushroomTimeInterval = 0;
        [self addMushroom];
    }
    
    self.lastSpawnPrawnTimeInterval += timeSinceLast;
    if (self.lastSpawnPrawnTimeInterval > 1) {
        self.lastSpawnPrawnTimeInterval = 0;
        [self addPrawn];
    }
}

- (void)update:(NSTimeInterval)currentTime {
    
    updateCalled++;
    
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
    [self enumerateChildNodesWithName:@"mushroom" usingBlock:^(SKNode *node, BOOL *stop) {
        //Eliminamos los champis que hayan pasado
        if (node.position.y < 0){
            [node removeFromParent];
        }
    }];
    
    [self enumerateChildNodesWithName:@"prawn" usingBlock:^(SKNode *node, BOOL *stop) {
        //Eliminamos las gambas que hayan pasado
        if (node.position.y < 0){
            [node removeFromParent];
        }
    }];
    
}

-(void)didMoveToView:(SKView *)view {
    [self createScene];
}

#pragma mark - Collision

-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    if(updateCalled != 0) {
        updateCalled = 0;
        
        SKPhysicsBody *firstBody;
        SKPhysicsBody *secondBody;
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        }
        else{
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        if([firstBody.node isKindOfClass:[MushroomNode class]]){
            if(firstBody.node.position.x >= self.bread.position.x-(self.bread.size.width/8)
               && firstBody.node.position.x <= self.bread.position.x+(self.bread.size.width/8)
               && contact.contactPoint.y >= self.bread.position.y+self.bread.size.height/2){
                
                if(self.bread.acceptMoreMushrooms){
                    [self.bread addMushroomCompletionBlock:^{
                        
                    }];
                    
                    [firstBody.node removeFromParent];
                }
                
            }
        }
        else if([firstBody.node isKindOfClass:[PrawnNode class]]){
            if(firstBody.node.position.x >= self.bread.position.x-(self.bread.size.width/6)
               && firstBody.node.position.x <= self.bread.position.x+(self.bread.size.width/6)
               && contact.contactPoint.y >= self.bread.position.y+self.bread.size.height/2){
                
                if(self.bread.acceptPrawn){
                    [self.bread addPrawnWithCompletionBlock:^{
                        
                    }];
                    
                    [firstBody.node removeFromParent];
                }
            }
        }

    }
}

#pragma mark - Touch

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    SKNode *touchedNode = [self nodeAtPoint:positionInScene];
    
    if([self.bread containsPoint:positionInScene]){
        moving = YES;
    }
    else if([touchedNode.name isEqualToString:@"pauseButton"]){
        [self tooglePause];
    }
    else if([touchedNode.name isEqualToString:@"continueButton"]){
        [self tooglePause];
    }
    else if([touchedNode.name isEqualToString:@"exitButton"]){
        [self.controller dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint positionInScene = [touch locationInNode:self];
	CGPoint previousPosition = [touch previousLocationInNode:self];
    //SKNode *touchedNode = [self nodeAtPoint:positionInScene];

    //if([touchedNode isEqualToNode:self.bread]){
    if(moving){
        CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
        
        [self panForTranslation:translation];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    moving = NO;
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
