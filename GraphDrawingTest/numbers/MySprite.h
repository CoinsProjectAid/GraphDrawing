//
//  MySprite.h
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/04.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface MySprite : NSObject <NSCopying>

@property (assign) GLKVector2 position;
//@property (readonly, assign) CGSize contentSize;
@property (assign) CGSize contentSize; //test
@property (assign) int value;
@property (strong) GLKBaseEffect *effect2;

@property (assign) float scale;

- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect value:(int)value;
- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect;

- (void)render;

@end
