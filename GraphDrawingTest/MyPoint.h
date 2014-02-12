//
//  MyPoint.h
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/06.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPoint : NSObject

@property (assign) float x;
@property (assign) float y;

+ (id)pointWithX:(float)x Y:(float)y;
- (BOOL)isEqual:(MyPoint *)point;
@end
