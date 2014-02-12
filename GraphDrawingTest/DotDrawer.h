//
//  dotDrawer.h
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/04.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface DotDrawer : NSObject

- (id)initWithEffect:(GLKBaseEffect *)effect;
- (void)render;
- (void)addDotAtX:(double)x Y:(double)y;

@end
