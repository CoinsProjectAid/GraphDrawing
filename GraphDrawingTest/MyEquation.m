//
//  MyEquation.m
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/07.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import "MyEquation.h"

@implementation MyEquation

- (id)initWithA3:(float)a3 a2:(float)a2 a1:(float)a1 a0:(float)a0 {
    self = [super init];
    if (self) {
        self.a3 = a3;
        self.a2 = a2;
        self.a1 = a1;
        self.a0 = a0;
    }
    
    return self;
}

- (id)init {
    return [self initWithA3:0 a2:0 a1:0 a0:0];
}

- (float)yForX:(float)x {
    return (self.a3 * x * x * x + self.a2 * x * x + self.a1 * x + self.a0);
}

- (int)degreeOfEquation {
    if (self.a3) {
        return 3;
    }
    if (self.a2) {
        return 2;
    }
    if (self.a1) {
        return 1;
    }
    return 1;
}

@end
