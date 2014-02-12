//
//  MyPoint.m
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/06.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import "MyPoint.h"

@implementation MyPoint

+ (id)pointWithX:(float)x Y:(float)y {
    MyPoint *point = [[MyPoint alloc] init];
    point.x = x;
    point.y = y;
    return point;
}

- (BOOL)isEqual:(MyPoint *)point {
    if (self.x == point.x && self.y == point.y) {
        return YES;
    }
    return NO;
}

@end
