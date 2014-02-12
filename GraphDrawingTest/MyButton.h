//
//  MyButton.h
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/12.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "MySprite.h"

@interface MyButton : NSObject

@property (assign, nonatomic) GLKVector2 position;
@property (assign, nonatomic) CGSize contentSize;

- (id)initWithSprite:(MySprite *)sprite;
- (void)render;
- (BOOL)isButtonTapped:(GLKVector2)touchLocation;

@end
