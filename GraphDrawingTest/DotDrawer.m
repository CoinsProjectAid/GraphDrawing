//
//  dotDrawer.m
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/04.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import "DotDrawer.h"
#import "Dot.h"

@interface DotDrawer ()

@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong, nonatomic) NSMutableArray *dots;

@end

@implementation DotDrawer

- (id)initWithEffect:(GLKBaseEffect *)effect {
    self = [super init];
    
    if (self) {
        self.effect = effect;
        
        self.dots = [NSMutableArray array];
    }
    
    return self;
}

- (void)render {
    NSLog(@"Dot Drawer preparing to draw");
    for (Dot *dot in self.dots) {
        NSLog(@"Dot Drawer drawing");
        [dot render];
    }
}

- (void)addDotAtX:(double)x Y:(double)y {
    NSLog(@"Dot gonna Add");
    Dot *dot = [[Dot alloc] initWithEffect:self.effect];
    dot.position = GLKVector2Make(x, y);
    
    [self.dots addObject:dot];
    
    NSLog(@"Dot added");
}

@end
