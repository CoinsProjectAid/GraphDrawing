//
//  GraphDrawer.h
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/03.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#define GRAPH_SIZE 700.0

@interface GraphDrawer : NSObject

@property (assign) int numHorizontal;
@property (assign) int numVertical;
@property (assign) GLKVector2 position;
@property (strong) GLKBaseEffect *effect;
@property (assign) double width;
@property (assign) double height;

- (id)initWithRows:(int)rows columns:(int)columns effect:(GLKBaseEffect *)effect;
- (id)initWithStartX:(double)startX endX:(double)endX spaceX:(double)spaceX startY:(double)startY endY:(double)endY spaceY:(double)spaceY effect:(GLKBaseEffect *)effect;
- (void)render;
- (void)choosePoint:(GLKVector2)pointLocation;
- (BOOL)choosePoint2:(GLKVector2)pointLocation;

- (BOOL)checkPoints;

@end
