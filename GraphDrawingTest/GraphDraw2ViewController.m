//
//  GraphDraw2ViewController.m
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/12.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import "GraphDraw2ViewController.h"
#import "GDTNode.h"
#import "NodeProtocol.h"

@interface GraphDraw2ViewController ()

@property (strong, nonatomic) GDTNode *gdtNode;
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) id <NodeProtocol> node;

@end

@implementation GraphDraw2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    NSAssert(self.context != nil, @"Failed to create ES context");
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    //view.drawableMultisample = GLKViewDrawableMultisample4X; //anti alias
    
    [EAGLContext setCurrentContext: self.context];
    
    //self.node = [[GDTNode alloc] init];
    
    self.node = [[GDTNode alloc] initWithStartX:-10 endX:10 spaceX:1 startY:-10 endY:10 spaceY:1 equation:[[MyEquation alloc] initWithA3:0 a2:0 a1:1 a0:3]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    [self.node handleTap:touchLocation];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    //glEnable(GL_BLEND);
    
    [self.node render];
}

@end
