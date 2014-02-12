//
//  GraphDrawViewController.m
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/03.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import "GraphDrawViewController.h"
#import "GraphDrawer.h"
#import "ZoomedMemoriDraw.h"

#import "EquationDraw.h"
#import "MyEquation.h"
#import "MemoriDraw.h"

#define SCREEN_WIDTH 1024
#define SCREEN_HEIGHT 768
#define ZOOMED_CELL_SIZE 300

@interface GraphDrawViewController ()

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong, nonatomic) GraphDrawer *graphDrawer;
@property (assign) BOOL is_zoomed;
@property (assign) GLKVector2 zoomedLocation;
@property (assign) double zoomedAdjustX;
@property (assign) double zoomedAdjustY;
@property (assign) double magnificationX;
@property (assign) double magnificationY;
@property (strong, nonatomic) ZoomedMemoriDraw *zoomedMemoriDrawer;

@property (strong) EquationDraw *equationDrawer;

@property (strong, nonatomic) MemoriDraw *memoriDrawer;

@end

@implementation GraphDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _is_zoomed = NO;
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    NSAssert(self.context != nil, @"Failed to create ES context");
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableMultisample = GLKViewDrawableMultisample4X; //anti alias
    
    [EAGLContext setCurrentContext: self.context];
    
    self.effect = [[GLKBaseEffect alloc] init];
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, SCREEN_WIDTH, 0, SCREEN_HEIGHT, 0, 0);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    //self.graphDrawer = [[GraphDrawer alloc] initWithRows:5 columns:5 effect:self.effect];
    self.graphDrawer = [[GraphDrawer alloc] initWithStartX:-10 endX:10 spaceX:1 startY:-10 endY:10 spaceY:1 effect:self.effect];
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
    self.zoomedMemoriDrawer.startX = -10;
    self.zoomedMemoriDrawer.startY = -10;
    self.zoomedMemoriDrawer.spaceX = 1;
    self.zoomedMemoriDrawer.spaceY = 1;
    
    NSLog(@"Cell width: %f height: %f", cell_width, cell_height);
    
    MyEquation *equation = [[MyEquation alloc] initWithA3:0 a2:1 a1:4 a0:2];
    self.equationDrawer = [[EquationDraw alloc] initWithEquation:equation minX:-10 maxX:10 spaceX:1 minY:-10 maxY:10 spaceY:1 cellWidth:cell_width cellHeight:cell_height effect:self.effect];
    self.equationDrawer.position = self.graphDrawer.position;
    
    self.memoriDrawer = [[MemoriDraw alloc] initWithStartX:-10 endX:10 spaceX:1 startY:-10 endY:10 spaceY:1 cellWidth:cell_width cellHeight:cell_height effect:self.effect];
    self.memoriDrawer.position = self.graphDrawer.position;
    [self.memoriDrawer setUp];
}

- (void)update {
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    [self.effect prepareToDraw];
    
    [self.graphDrawer render];
    [self.zoomedMemoriDrawer render]; //test
    
    if (!_is_zoomed)
        [self.memoriDrawer render];
    
    [self.equationDrawer render];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_is_zoomed) {
        _is_zoomed = YES;
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView:self.view];
        _zoomedLocation = GLKVector2Make(touchLocation.x, SCREEN_HEIGHT - touchLocation.y);
        GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(touchLocation.x - _zoomedAdjustX, touchLocation.x + _zoomedAdjustX, SCREEN_HEIGHT - touchLocation.y - _zoomedAdjustY, SCREEN_HEIGHT - touchLocation.y + _zoomedAdjustY, 0, 0);
        self.effect.transform.projectionMatrix = projectionMatrix;
        //test below
        NSLog(@"zoomedX: %f zoomedY: %f", _zoomedLocation.x, _zoomedLocation.y);
        self.zoomedMemoriDrawer.isShowed = YES;
        self.zoomedMemoriDrawer.positionZoomed = GLKVector2Make(_zoomedLocation.x - self.graphDrawer.position.x, _zoomedLocation.y - self.graphDrawer.position.y);
        [self.zoomedMemoriDrawer setUp];
    } else {
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView:self.view];
        touchLocation = CGPointMake((touchLocation.x - SCREEN_WIDTH/2.0)/_magnificationX, (SCREEN_HEIGHT/2.0 - touchLocation.y)/_magnificationY);
        GLKVector2 pointLocation = GLKVector2Make(_zoomedLocation.x + touchLocation.x, _zoomedLocation.y + touchLocation.y);
        if ([self.graphDrawer choosePoint2:pointLocation]) {
            self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, SCREEN_WIDTH, 0, SCREEN_HEIGHT, 0, 0);
            _is_zoomed = NO;
            self.zoomedMemoriDrawer.isShowed = NO; //testing
        }
    }
}


@end
