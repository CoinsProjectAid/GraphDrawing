//
//  MyNumber.m
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/05.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import "MyNumber.h"
#import "MySprite.h"

@interface MyNumber ()

@property (strong, nonatomic) NSMutableArray *myNumber;
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (assign) int precision;
@property (strong, nonatomic) NumberSprites *numberSprites;

@end

@implementation MyNumber

- (id)initWithNumber:(float)number effect:(GLKBaseEffect *)effect {
    self = [super init];
    
    if (self) {
        self.numberSprites = [NumberSprites numberSpritesWithEffect:effect]; //test
        self.myNumber = [NSMutableArray array];
        self.contentSize = CGSizeMake(0, 0);
        self.precision = 2;
        self.scale = 1.0;
        
        self.effect = effect;
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        int dotichi = 0;
        BOOL negative = (number >= 0) ? NO : YES;
        if (negative) {
            number *= -1;
        }
        BOOL addZeroBefore = (number >= 0 && number < 1) ? YES : NO;
        
        for (; dotichi < self.precision && number - (int)number > 0; dotichi++) {
            number *= 10.0;
        }
        
        int seisuu = number;
        
        while (seisuu > 0) {
            int value = seisuu - ((int)seisuu/10) * 10;
            NSString *path = [NSString stringWithFormat:@"nn%d.png", value];
            MySprite *sprite = [[MySprite alloc] initWithFile:path effect:self.effect value:value];
            [tempArray addObject:sprite];
            self.contentSize = CGSizeMake(self.contentSize.width + sprite.contentSize.width, sprite.contentSize.height);
            seisuu /= 10;
        }
        /*
        while (seisuu > 0) {
            int value = seisuu - ((int)seisuu/10) * 10;
            MySprite *sprite = [self.numberSprites number:value];
            [tempArray addObject:sprite];
            self.contentSize = CGSizeMake(self.contentSize.width + sprite.contentSize.width, sprite.contentSize.height);
            seisuu /= 10;
        }*/
        
        if (dotichi) {
            MySprite *sprite = [[MySprite alloc] initWithFile:@"nnDot.png" effect:self.effect value:10];
            [tempArray insertObject:sprite atIndex:dotichi];
            self.contentSize = CGSizeMake(self.contentSize.width + sprite.contentSize.width, self.contentSize.height);
        }
        /*
        if (dotichi) {
            MySprite *sprite = [self.numberSprites number:VALUE_DOT];
            [tempArray insertObject:sprite atIndex:dotichi];
            self.contentSize = CGSizeMake(self.contentSize.width + sprite.contentSize.width, self.contentSize.height);
        }*/
        
        if (addZeroBefore) {
            MySprite *sprite = [[MySprite alloc] initWithFile:@"nn0.png" effect:self.effect value:0];
            [tempArray addObject:sprite];
            self.contentSize = CGSizeMake(self.contentSize.width + sprite.contentSize.width, sprite.contentSize.height);
        }
        /*
        if (addZeroBefore) {
            MySprite *sprite = [self.numberSprites number:0];
            [tempArray addObject:sprite];
            self.contentSize = CGSizeMake(self.contentSize.width + sprite.contentSize.width, sprite.contentSize.height);
        }*/
        
        if (negative) {
            MySprite *sprite = [[MySprite alloc] initWithFile:@"nnMinus.png" effect:self.effect value:12];
            [tempArray addObject:sprite];
            self.contentSize = CGSizeMake(self.contentSize.width + sprite.contentSize.width, self.contentSize.height);
        }
        /*
        if (negative) {
            MySprite *sprite = [self.numberSprites number:VALUE_MINUS];
            [tempArray addObject:sprite];
            self.contentSize = CGSizeMake(self.contentSize.width + sprite.contentSize.width, self.contentSize.height);
        }*/
        
        NSEnumerator *enumerator = [tempArray reverseObjectEnumerator];
        for (MySprite *sprite in enumerator) {
            [self.myNumber addObject:sprite];
        }
    }
    
    return self;
}

- (id)initWithNumber:(float)number scale:(float)scale effect:(GLKBaseEffect *)effect {
    self = [super init];
    
    if (self) {
        self.myNumber = [NSMutableArray array];
        self.contentSize = CGSizeMake(0, 0);
        self.precision = 2;
        self.scale = scale;
        
        self.effect = effect;
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        int dotichi = 0;
        BOOL negative = (number >= 0) ? NO : YES;
        if (negative) {
            number *= -1;
        }
        BOOL addZeroBefore = (number >= 0 && number < 1) ? YES : NO;
        
        for (; dotichi < self.precision && number - (int)number > 0; dotichi++) {
            number *= 10.0;
        }
        
        int seisuu = number;
        
        while (seisuu > 0) {
            int value = seisuu - ((int)seisuu/10) * 10;
            NSString *path = [NSString stringWithFormat:@"nn%d.png", value];
            MySprite *sprite = [[MySprite alloc] initWithFile:path effect:self.effect value:value];
            [tempArray addObject:sprite];
            self.contentSize = CGSizeMake(self.contentSize.width + sprite.contentSize.width, sprite.contentSize.height);
            seisuu /= 10;
        }
        
        if (dotichi) {
            MySprite *sprite = [[MySprite alloc] initWithFile:@"nnDot.png" effect:self.effect value:10];
            [tempArray insertObject:sprite atIndex:dotichi];
            self.contentSize = CGSizeMake(self.contentSize.width + sprite.contentSize.width, self.contentSize.height);
        }
        
        if (addZeroBefore) {
            MySprite *sprite = [[MySprite alloc] initWithFile:@"nn0.png" effect:self.effect value:0];
            [tempArray addObject:sprite];
            self.contentSize = CGSizeMake(self.contentSize.width + sprite.contentSize.width, sprite.contentSize.height);
        }
        
        if (negative) {
            MySprite *sprite = [[MySprite alloc] initWithFile:@"nnMinus.png" effect:self.effect value:12];
            [tempArray addObject:sprite];
            self.contentSize = CGSizeMake(self.contentSize.width + sprite.contentSize.width, self.contentSize.height);
        }
        
        NSEnumerator *enumerator = [tempArray reverseObjectEnumerator];
        for (MySprite *sprite in enumerator) {
            [self.myNumber addObject:sprite];
        }
        
        self.contentSize = CGSizeMake(self.contentSize.width * self.scale, self.contentSize.height * self.scale);
    }
    
    return self;
}

- (void)setUp {
    CGSize center = CGSizeMake(self.contentSize.width/2.0, self.contentSize.height/2.0); //first find out where the center is
    int count = 0;
    int numSprites = [self.myNumber count];
    
    //--test--
    for (MySprite *sprite in self.myNumber) {
        sprite.contentSize = CGSizeMake(sprite.contentSize.width * self.scale, sprite.contentSize.height * self.scale);
        sprite.scale = self.scale;
    }
    //--------
    
    if (numSprites == 0) {
        return;
    } else if (numSprites == 1) {
        MySprite *sprite = [self.myNumber objectAtIndex:0];
        sprite.position = self.position;
        return;
    }
    float size = 0.0;
    
    for (MySprite *sprite in self.myNumber) {
        size += sprite.contentSize.width;
        if (size > center.width) {
            break;
        }
        count++;
    }
    //now we know which sprite has the center so next we figure out the zure of the center object's center and the actual center of all objects
    float sizeBeforeCenter = 0.0;
    
    for (int i = 0; i < count; i++) {
        sizeBeforeCenter += ((MySprite *)[self.myNumber objectAtIndex:i]).contentSize.width;
    }
    
    float zure = center.width - sizeBeforeCenter;
    //now we use this to figure out actual position to put the center object
    MySprite *centerSprite = [self.myNumber objectAtIndex:count];
    float centerZure = centerSprite.contentSize.width/2.0 - zure;
    centerSprite.position = GLKVector2Make(self.position.x + centerZure, self.position.y);
    
    //next set position right of center
    float startRight = centerSprite.position.x + centerSprite.contentSize.width/2.0;
    for (int i = count + 1; i < numSprites; i++) {
        MySprite *rightSprite = [self.myNumber objectAtIndex:i];
        rightSprite.position = GLKVector2Make(startRight + rightSprite.contentSize.width/2.0, self.position.y);
        startRight += rightSprite.contentSize.width;
    }
    //finally set position left of center
    float startLeft = centerSprite.position.x - centerSprite.contentSize.width/2.0;
    for (int i = count - 1; i >= 0; i--) {
        MySprite *leftSprite = [self.myNumber objectAtIndex:i];
        leftSprite.position = GLKVector2Make(startLeft - leftSprite.contentSize.width/2.0, self.position.y);
        startLeft -= leftSprite.contentSize.width;
    }
}

- (void)render {
    for (MySprite *sprite in self.myNumber) {
        [sprite render];
    }
    
}

@end
