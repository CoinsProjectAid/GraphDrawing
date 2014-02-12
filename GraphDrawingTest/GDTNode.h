//
//  GDTNode.h
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/10.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "NodeProtocol.h"
#import "MyEquation.h"

@interface GDTNode : NSObject <NodeProtocol>

- (id)init;
- (id)initWithStartX:(float)startX endX:(float)endX spaceX:(float)spaceX startY:(float)startY endY:(float)endY spaceY:(float)spaceY equation:(MyEquation *)equation;


@end
