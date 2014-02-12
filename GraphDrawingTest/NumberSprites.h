//
//  NumberSprites.h
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/12.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "MySprite.h"

enum {
    VALUE_DOT = 10,
    VALUE_MINUS
};

@interface NumberSprites : NSObject

- (id)initWithEffect:(GLKBaseEffect *)effect;
- (MySprite *)number:(int)value;
+ (NumberSprites *)numberSpritesWithEffect:(GLKBaseEffect *)effect;

@end
