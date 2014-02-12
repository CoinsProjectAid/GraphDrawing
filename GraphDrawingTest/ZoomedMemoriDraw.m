//
//  ZoomedMemoriDraw.m
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/05.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import "ZoomedMemoriDraw.h"
#import "MySprite.h"
#import "MyNumber.h"

#define SCREEN_WIDTH 1024
#define SCREEN_HEIGHT 768

@interface ZoomedMemoriDraw ()

@property (strong) GLKBaseEffect *effect;
//@property (strong, nonatomic) NSMutableArray *numbers;
@property (strong) NSMutableArray *displayedNumbers;

//@property (strong) MySprite *testSprite;


@end

@implementation ZoomedMemoriDraw

- (id)init {
    self = [super init];
    
    if (self) {
        _isShowed = NO;
        _effect = [[GLKBaseEffect alloc] init];
        _effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, SCREEN_WIDTH, 0, SCREEN_HEIGHT, 0, 0);
        
        //_effect.transform.modelviewMatrix = GLKMatrix4Scale(GLKMatrix4Identity, 0.5, 0.5, 0); //temp
        
        //self.numbers = [NSMutableArray array];
        self.displayedNumbers = [NSMutableArray array];
        
    }
    
    return self;
}

- (void)setUp {
    [self.displayedNumbers removeAllObjects];
    
    double adjustX = self.positionZoomed.x / self.cellWidth;
    double adjustY = self.positionZoomed.y / self.cellHeight;
    
    double xCoord = self.startX + (int)adjustX * self.spaceX;
    double yCoord = self.startY + (int)adjustY * self.spaceY;
    
    adjustX = adjustX - (int)adjustX;
    adjustY = adjustY - (int)adjustY;
    
    adjustX = adjustX*self.cellWidth;
    adjustY = adjustY*self.cellHeight;
    
    
    //double startX = SCREEN_WIDTH/2 - adjustX*self.magnificationX;
    //double startY = SCREEN_HEIGHT/2 - adjustY*self.magnificationY;
    
    
    double zoomedCellWidth = self.magnificationX * self.cellWidth;
    double zoomedCellHeight = self.magnificationY * self.cellHeight;
    
    double posX = SCREEN_WIDTH/2 - adjustX*self.magnificationX;
    double posY = SCREEN_HEIGHT/2 - adjustY*self.magnificationY;
    
    do {
        posX += zoomedCellWidth;
        xCoord += self.spaceX;
    } while (posX <= SCREEN_WIDTH);
    
    do {
        posY += zoomedCellHeight;
        yCoord += self.spaceY;
    } while (posY <= SCREEN_HEIGHT);
    
    while (posX >= 0) {
        /*
        MySprite *sprite = [[MySprite alloc] initWithFile:@"n3.png" effect:self.effect value:3];
        sprite.position = GLKVector2Make(posX, SCREEN_HEIGHT - sprite.contentSize.height/2);
        [self.displayedNumbers addObject:sprite];
        posX -= zoomedCellWidth; */
        
    
        MyNumber *myNumber = [[MyNumber alloc] initWithNumber:xCoord effect:self.effect];
        myNumber.position = GLKVector2Make(posX, SCREEN_HEIGHT - myNumber.contentSize.height/2.0);
        [myNumber setUp];
        [self.displayedNumbers addObject:myNumber];
        posX -= zoomedCellWidth;
        xCoord -= self.spaceX;
    }
    
    while (posY >= 0) {
        /*
        MySprite *sprite = [[MySprite alloc] initWithFile:@"n2.png" effect:self.effect value:2];
        sprite.position = GLKVector2Make(sprite.contentSize.width/2, posY);
        [self.displayedNumbers addObject:sprite];
        posY -= zoomedCellHeight; */
        
        
        MyNumber *myNumber = [[MyNumber alloc] initWithNumber:yCoord effect:self.effect];
        myNumber.position = GLKVector2Make(myNumber.contentSize.width/2.0, posY);
        [myNumber setUp];
        [self.displayedNumbers addObject:myNumber];
        posY -= zoomedCellHeight;
        yCoord -= self.spaceY;
    }
    
    //self.testSprite = [[MySprite alloc] initWithFile:@"n4.png" effect:self.effect value:4];
    //self.testSprite.position = GLKVector2Make(startX, startY);
}

- (void)render {
    /*
    if (_isShowed) {
        for (MySprite *sprite in self.displayedNumbers) {
            [sprite render];
        }
    }*/
    
    if (_isShowed) {
        for (MyNumber *number in self.displayedNumbers) {
            [number render];
        }
    }
}

@end
