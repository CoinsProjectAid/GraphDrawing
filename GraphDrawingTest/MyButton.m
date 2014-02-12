//
//  MyButton.m
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/12.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import "MyButton.h"

@interface MyButton ()

@property (strong, nonatomic) MySprite *sprite;

@end

@implementation MyButton

- (id)initWithSprite:(MySprite *)sprite {
    self = [super init];
    if (self) {
        self.sprite = sprite;
    }
    return self;
}

- (void)render {
    self.sprite.position = self.position;
    [self.sprite render];
}

- (BOOL)isButtonTapped:(GLKVector2)touchLocation {
    float left = self.position.x - self.sprite.contentSize.width/2.0;
    float right = self.position.x + self.sprite.contentSize.width/2.0;
    float bottom = self.position.y - self.sprite.contentSize.height/2.0;
    float top = self.position.y + self.sprite.contentSize.height/2.0;
    
    if (touchLocation.x >= left && touchLocation.x <= right && touchLocation.y <= top && touchLocation.y >= bottom) {
        return YES;
    }
    
    return NO;
}

- (CGSize)contentSize {
    return self.sprite.contentSize;
}

@end
