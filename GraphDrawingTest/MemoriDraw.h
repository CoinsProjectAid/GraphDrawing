//
//  MemoriDraw.h
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/05.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface MemoriDraw : NSObject

@property (assign) GLKVector2 position;

- (id)initWithStartX:(float)startX endX:(float)endX spaceX:(float)spaceX startY:(float)startY endY:(float)endY spaceY:(float)spaceY cellWidth:(float)cellWidth cellHeight:(float)cellHeight effect:(GLKBaseEffect *)effect;

- (void)render;
- (void)setUp;

@end
