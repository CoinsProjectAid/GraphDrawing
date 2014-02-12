//
//  EquationDraw.h
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/07.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphDrawingProtocol.h"
#import <GLKit/GLKit.h>

@interface EquationDraw : NSObject

@property (assign) GLKVector2 position;

- (id)initWithEquation:(id <GraphDrawingProtocol>)equation minX:(float)minX maxX:(float)maxX spaceX:(float)spaceX minY:(float)minY maxY:(float)maxY spaceY:(float)spaceY cellWidth:(float)cellWidth cellHeight:(float)cellHeight effect:(GLKBaseEffect *)effect;

- (void)render;

@end
