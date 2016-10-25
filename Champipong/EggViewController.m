//
//  EggViewController.m
//  smartcity
//
//  Created by David on 27/9/16.
//  Copyright © 2016 jgurria. All rights reserved.
//

#import "EggViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "EggScene.h"

@interface EggViewController ()

@property (nonatomic, strong) EggScene *scene;

@end

@implementation EggViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.scene = [[EggScene alloc] initWithSize:self.view.bounds.size];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:NULL];
    
    if(self.scene){
        CGRect size;
        if(self.view.bounds.size.height > self.view.bounds.size.width){
            size = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.height, self.view.bounds.size.width);
        }
        else{
            size = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
        }
        
        SKView *skView = [[SKView alloc] initWithFrame:size];
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        skView.ignoresSiblingOrder = YES;
        
        self.scene.scaleMode = SKSceneScaleModeAspectFill;
        self.scene.size = size.size;
        self.scene.controller = self;
        
        [skView presentScene:self.scene];
        
        [self.view addSubview:skView];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)applicationWillResignActive {
    self.scene.paused = YES;
}

-(void)applicationDidEnterBackground {
    self.scene.paused = YES;
}

-(void)applicationWillEnterForeground {
    self.scene.paused = YES;
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

@end
