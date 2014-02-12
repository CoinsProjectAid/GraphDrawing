//
//  NodeProtocol.h
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/12.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    STATE_NULL,
    STATE_GRAPH,
    STATE_CALCULATE
} stateID;

@protocol NodeProtocol

@property (assign) stateID nextStateID;

- (void)render;
- (void)handleTap:(CGPoint)touchLocation;

@end
