//
//  MyEquation.h
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/07.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphDrawingProtocol.h"

//a3x^3 + a2x^2 + a1x + a0

@interface MyEquation : NSObject <GraphDrawingProtocol>

@property (assign) float a3;
@property (assign) float a2;
@property (assign) float a1;
@property (assign) float a0;

- (id)init;
- (id)initWithA3:(float)a3 a2:(float)a2 a1:(float)a1 a0:(float)a0;

- (float)yForX:(float)x;

@end
