//
//  MyNumber.h
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/05.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "NumberSprites.h"

@interface MyNumber : NSObject

@property (assign) GLKVector2 position;
@property (assign) CGSize contentSize;
@property (assign) float scale;

- (id)initWithNumber:(float)number effect:(GLKBaseEffect *)effect;
- (id)initWithNumber:(float)number scale:(float)scale effect:(GLKBaseEffect *)effect;
- (void)render;
- (void)setUp;

@end
