//
//  CalculatingNode.m
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/12.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import "CalculatingNode.h"
#import "MySprite.h"
#import "MyButton.h"

#define SCREEN_WIDTH 1024
#define SCREEN_HEIGHT 768

@interface CalculatingNode ()

@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong, nonatomic) NSMutableArray *buttons;

@end

@implementation CalculatingNode

@synthesize nextStateID;

- (id)initWithEffect:(GLKBaseEffect *)effect {
    self = [super init];
    if (self) {
        self.effect = [[GLKBaseEffect alloc] init];
        
        GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, SCREEN_WIDTH, 0, SCREEN_HEIGHT, 0, 0);
        self.effect.transform.projectionMatrix = projectionMatrix;
        
        MyButton *button = [[MyButton alloc] initWithSprite:[[MySprite alloc] initWithFile:@"drawButton.png" effect:self.effect]];
        button.position = GLKVector2Make(100, 100);
        [self.buttons addObject:button];
    }
    
    return self;
}

- (void)render {
    for (MyButton *button in self.buttons) {
        [button render];
    }
}

- (void)handleTap:(CGPoint)touchLocation {
    
}

@end
