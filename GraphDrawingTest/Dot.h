//
//  Dot.h
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/04.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Dot : NSObject <NSCopying>

@property (assign) GLKVector2 position;
@property (assign) GLKVector2 point;

- (id)initWithEffect:(GLKBaseEffect *)effect;
- (void)render;

@end
