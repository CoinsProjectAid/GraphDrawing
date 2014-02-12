//
//  GDTNode.m
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/10.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import "GDTNode.h"
#import "GraphDrawer.h"
#import "ZoomedMemoriDraw.h"

#import "EquationDraw.h"
#import "MyEquation.h"
#import "MemoriDraw.h"

#import "MyButton.h"

#define SCREEN_WIDTH 1024
#define SCREEN_HEIGHT 768
#define ZOOMED_CELL_SIZE 300

@interface GDTNode ()

@property (strong, nonatomic) GraphDrawer *graphDrawer;
@property (strong, nonatomic) GLKBaseEffect *effect;

@property (assign) BOOL is_zoomed;
@property (assign) GLKVector2 zoomedLocation;
@property (assign) double zoomedAdjustX;
@property (assign) double zoomedAdjustY;
@property (assign) double magnificationX;
@property (assign) double magnificationY;
@property (strong, nonatomic) ZoomedMemoriDraw *zoomedMemoriDrawer;
@property (strong, nonatomic) MyEquation *equation;

@property (strong, nonatomic) EquationDraw *equationDrawer;

@property (strong, nonatomic) MemoriDraw *memoriDrawer;

@property (strong, nonatomic) NSMutableArray *buttons;

@property (assign, nonatomic) BOOL isGraphShown;

@end

@implementation GDTNode

@synthesize nextStateID;

- (id)init {
    self = [super init];
    
    if (self) {
        self.nextStateID = STATE_NULL;
        
        self.effect = [[GLKBaseEffect alloc] init];
        
        GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, SCREEN_WIDTH, 0, SCREEN_HEIGHT, 0, 0);
        self.effect.transform.projectionMatrix = projectionMatrix;
    
        self.graphDrawer = [[GraphDrawer alloc] initWithStartX:-20 endX:5 spaceX:0.5 startY:-20 endY:5 spaceY:0.5 effect:self.effect];
        self.graphDrawer.position = GLKVector2Make((SCREEN_HEIGHT - GRAPH_SIZE)/2.0, (SCREEN_HEIGHT - GRAPH_SIZE)/2.0);
    
        double cell_width = self.graphDrawer.width;
        double cell_height = self.graphDrawer.height;
        _magnificationX = ZOOMED_CELL_SIZE/cell_width;
        _magnificationY = ZOOMED_CELL_SIZE/cell_height;
        _zoomedAdjustX = (SCREEN_WIDTH/_magnificationX)/2.0;
        _zoomedAdjustY = (SCREEN_HEIGHT/_magnificationY)/2.0;
    
        self.zoomedMemoriDrawer = [[ZoomedMemoriDraw alloc] init];
        self.zoomedMemoriDrawer.magnificationX = _magnificationX;
        self.zoomedMemoriDrawer.magnificationY = _magnificationY;
        self.zoomedMemoriDrawer.cellWidth = cell_width;
        self.zoomedMemoriDrawer.cellHeight = cell_height;
        self.zoomedMemoriDrawer.startX = -20;
        self.zoomedMemoriDrawer.startY = -20;
        self.zoomedMemoriDrawer.spaceX = 0.5;
        self.zoomedMemoriDrawer.spaceY = 0.5;
    
        NSLog(@"Cell width: %f height: %f", cell_width, cell_height);
    
        MyEquation *equation = [[MyEquation alloc] initWithA3:0 a2:1 a1:4 a0:2];
        self.equationDrawer = [[EquationDraw alloc] initWithEquation:equation minX:-20 maxX:5 spaceX:0.5 minY:-20 maxY:5 spaceY:0.5 cellWidth:cell_width cellHeight:cell_height effect:self.effect];
        self.equationDrawer.position = self.graphDrawer.position;
    
        self.memoriDrawer = [[MemoriDraw alloc] initWithStartX:-20 endX:5 spaceX:0.5 startY:-20 endY:5 spaceY:0.5 cellWidth:cell_width cellHeight:cell_height effect:self.effect];
        self.memoriDrawer.position = self.graphDrawer.position;
        [self.memoriDrawer setUp];
        
        
    }
    
    return self;
}

- (id)initWithStartX:(float)startX endX:(float)endX spaceX:(float)spaceX startY:(float)startY endY:(float)endY spaceY:(float)spaceY equation:(MyEquation *)equation {
    
    self = [super init];
    
    if (self) {
        self.nextStateID = STATE_NULL;
        
        self.effect = [[GLKBaseEffect alloc] init];
        
        GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, SCREEN_WIDTH, 0, SCREEN_HEIGHT, 0, 0);
        self.effect.transform.projectionMatrix = projectionMatrix;
        
        self.graphDrawer = [[GraphDrawer alloc] initWithStartX:startX endX:endX spaceX:spaceX startY:startY endY:endY spaceY:spaceY effect:self.effect];
        self.graphDrawer.position = GLKVector2Make((SCREEN_HEIGHT - GRAPH_SIZE)/2.0, (SCREEN_HEIGHT - GRAPH_SIZE)/2.0);
        
        double cell_width = self.graphDrawer.width;
        double cell_height = self.graphDrawer.height;
        _magnificationX = ZOOMED_CELL_SIZE/cell_width;
        _magnificationY = ZOOMED_CELL_SIZE/cell_height;
        _zoomedAdjustX = (SCREEN_WIDTH/_magnificationX)/2.0;
        _zoomedAdjustY = (SCREEN_HEIGHT/_magnificationY)/2.0;
        
        self.zoomedMemoriDrawer = [[ZoomedMemoriDraw alloc] init];
        self.zoomedMemoriDrawer.magnificationX = _magnificationX;
        self.zoomedMemoriDrawer.magnificationY = _magnificationY;
        self.zoomedMemoriDrawer.cellWidth = cell_width;
        self.zoomedMemoriDrawer.cellHeight = cell_height;
        self.zoomedMemoriDrawer.startX = startX;
        self.zoomedMemoriDrawer.startY = startY;
        self.zoomedMemoriDrawer.spaceX = spaceX;
        self.zoomedMemoriDrawer.spaceY = spaceY;
        
        NSLog(@"Cell width: %f height: %f", cell_width, cell_height);
        
        self.equation = equation;
        self.equationDrawer = [[EquationDraw alloc] initWithEquation:self.equation minX:startX maxX:endX spaceX:spaceX minY:startY maxY:endY spaceY:spaceY cellWidth:cell_width cellHeight:cell_height effect:self.effect];
        self.equationDrawer.position = self.graphDrawer.position;
        
        self.memoriDrawer = [[MemoriDraw alloc] initWithStartX:startX endX:endX spaceX:spaceX startY:startY endY:endY spaceY:spaceY cellWidth:cell_width cellHeight:cell_height effect:self.effect];
        self.memoriDrawer.position = self.graphDrawer.position;
        [self.memoriDrawer setUp];
        
        self.buttons = [NSMutableArray array];
        
        MyButton *button = [[MyButton alloc] initWithSprite:[[MySprite alloc] initWithFile:@"drawButton.png" effect:self.effect]];
        button.position = GLKVector2Make(SCREEN_WIDTH - button.contentSize.width/2.0, SCREEN_HEIGHT - button.contentSize.height/2.0);
        [self.buttons addObject:button];
        
        _isGraphShown = NO;
    }
    
    return self;
}

- (void)render {
    [self.graphDrawer render];
    [self.zoomedMemoriDrawer render]; //test
    
    if (!_is_zoomed)
        [self.memoriDrawer render];
    
    if (_isGraphShown)
        [self.equationDrawer render];
    
    for (MyButton *button in self.buttons) {
        [button render];
    }
}

- (void)handleTap:(CGPoint)touchLocation {
    for (MyButton *button in self.buttons) {
        if ([button isButtonTapped:GLKVector2Make(touchLocation.x, SCREEN_HEIGHT - touchLocation.y)]) {
            if (self.graphDrawer.checkPoints)
                _isGraphShown = YES;
            return;
        }
    }
    if (!_is_zoomed) {
        _is_zoomed = YES;
        _zoomedLocation = GLKVector2Make(touchLocation.x, SCREEN_HEIGHT - touchLocation.y);
        GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(touchLocation.x - _zoomedAdjustX, touchLocation.x + _zoomedAdjustX, SCREEN_HEIGHT - touchLocation.y - _zoomedAdjustY, SCREEN_HEIGHT - touchLocation.y + _zoomedAdjustY, 0, 0);
        self.effect.transform.projectionMatrix = projectionMatrix;
        //test below
        NSLog(@"zoomedX: %f zoomedY: %f", _zoomedLocation.x, _zoomedLocation.y);
        self.zoomedMemoriDrawer.isShowed = YES;
        self.zoomedMemoriDrawer.positionZoomed = GLKVector2Make(_zoomedLocation.x - self.graphDrawer.position.x, _zoomedLocation.y - self.graphDrawer.position.y);
        [self.zoomedMemoriDrawer setUp];
    } else {
        touchLocation = CGPointMake((touchLocation.x - SCREEN_WIDTH/2.0)/_magnificationX, (SCREEN_HEIGHT/2.0 - touchLocation.y)/_magnificationY);
        GLKVector2 pointLocation = GLKVector2Make(_zoomedLocation.x + touchLocation.x, _zoomedLocation.y + touchLocation.y);
        if ([self.graphDrawer choosePoint2:pointLocation]) {
            self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, SCREEN_WIDTH, 0, SCREEN_HEIGHT, 0, 0);
            _is_zoomed = NO;
            self.zoomedMemoriDrawer.isShowed = NO; //testing
        }
    }
}

- (void)equationStringDraw {
    
}

@end
