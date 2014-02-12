//
//  ZoomedMemoriDraw.h
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/05.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface ZoomedMemoriDraw : NSObject

@property (assign) GLKVector2 positionZoomed; //x,y location on graph, not coordinate on graph
@property (assign) BOOL isShowed;
@property (assign) double cellWidth;
@property (assign) double cellHeight;
//@property (assign) double zoomedCellWidth;
//@property (assign) double zoomedCellHeight;

@property (assign) double magnificationX;
@property (assign) double magnificationY;

@property (assign) double startX;
@property (assign) double startY;
@property (assign) double spaceX;
@property (assign) double spaceY;

- (id)init;
- (void)render;

- (void)setUp; //temp

@end
