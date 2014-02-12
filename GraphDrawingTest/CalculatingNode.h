//
//  CalculatingNode.h
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/12.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeProtocol.h"
#import <GLKit/GLKit.h>

@interface CalculatingNode : NSObject <NodeProtocol>

- (id)initWithEffect:(GLKBaseEffect *)effect;

@end
