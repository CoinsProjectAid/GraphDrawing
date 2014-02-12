//
//  MemoriDraw.m
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/05.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import "MemoriDraw.h"
#import "MyNumber.h"

@interface MemoriDraw ()

@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong, nonatomic) NSMutableArray *numbers;
@property (assign) float startX;
@property (assign) float startY;
@property (assign) float endX;
@property (assign) float endY;
@property (assign) float spaceX;
@property (assign) float spaceY;
@property (assign) float cellWidth;
@property (assign) float cellHeight;

@end

@implementation MemoriDraw

- (id)initWithStartX:(float)startX endX:(float)endX spaceX:(float)spaceX startY:(float)startY endY:(float)endY spaceY:(float)spaceY cellWidth:(float)cellWidth cellHeight:(float)cellHeight effect:(GLKBaseEffect *)effect {
    self = [super init];
    if (self) {
        self.effect = effect;
        self.numbers = [NSMutableArray array];
        self.position = GLKVector2Make(0, 0);
        
        self.startX = startX;
        self.startY = startY;
        self.endX = endX;
        self.endY = endY;
        self.spaceX = spaceX;
        self.spaceY = spaceY;
        self.cellWidth = cellWidth;
        self.cellHeight = cellHeight;
    }
    return self;
}

- (void)setUp {
    float startXPos = (-1.0*self.startY*self.cellHeight)/self.spaceY; //x jiku no y ichi
    float startYPos = (-1.0*self.startX*self.cellWidth)/self.spaceX; //y jiku no x ichi
    
    int x = (self.endX - self.startX)/self.spaceX; //x memori kosuu
    int y = (self.endY - self.startY)/self.spaceY; //y memori kosuu
    
    float xVal = self.startX;
    float yVal = self.startY;
    
    float maxSize = 0;
    
    for (int i = 0; i <= x; i++) {
        MyNumber *number = [[MyNumber alloc]initWithNumber:xVal effect:self.effect];
        //number.position = GLKVector2Make(self.position.x + self.cellWidth*i, self.position.y + startXPos - number.contentSize.height/2 - 3);
        //[number setUp];
        if (number.contentSize.width > maxSize) {
            maxSize = number.contentSize.width;
        }
        xVal+=self.spaceX;
    }

    for (int i = 0; i <= y; i++) {
        if (yVal == 0) {
            yVal+=self.spaceY;
            continue;
        }
        MyNumber *number = [[MyNumber alloc] initWithNumber:yVal effect:self.effect];
        //number.position = GLKVector2Make(self.position.x + startYPos + number.contentSize.width/2 + 3, self.position.y + self.cellHeight*i);
        //[number setUp];
        if (number.contentSize.width > maxSize) {
            maxSize = number.contentSize.width;
        }
        yVal+=self.spaceY;
    }
    
    float scale = (self.cellWidth - self.cellWidth/20)/maxSize;
    xVal = self.startX;
    yVal = self.startY;
    for (int i = 0; i <= x; i++) {
        MyNumber *number = [[MyNumber alloc] initWithNumber:xVal scale:scale effect:self.effect];
        number.position = GLKVector2Make(self.position.x + self.cellWidth*i, self.position.y + startXPos - number.contentSize.height/2 - 3);
        [number setUp];
        [self.numbers addObject:number];
        xVal += self.spaceX;
    }
    for (int i = 0; i <= y; i++) {
        if (yVal == 0) {
            yVal += self.spaceY;
            continue;
        }
        MyNumber *number = [[MyNumber alloc] initWithNumber:yVal scale:scale effect:self.effect];
        number.position = GLKVector2Make(self.position.x + startYPos + number.contentSize.width/2 + 3, self.position.y + self.cellHeight*i);
        [number setUp];
        [self.numbers addObject:number];
        yVal += self.spaceY;
    }
}

- (void)render {
    for (MyNumber *number in self.numbers) {
        [number render];
    }
}

@end
