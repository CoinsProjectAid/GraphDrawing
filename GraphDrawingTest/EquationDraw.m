//
//  EquationDraw.m
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/07.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import "EquationDraw.h"

#define NUM_VERTICES 1000

typedef struct {
    GLKVector2 position;
    GLKVector4 color;
} Vertex;

@interface EquationDraw () {
    GLuint _lineBuffer;
}

@property (strong) GLKBaseEffect *effect;
@property (strong) id <GraphDrawingProtocol> equation;
@property (assign) float minX;
@property (assign) float maxX;
@property (assign) float minY;
@property (assign) float maxY;
@property (assign) float spaceX;
@property (assign) float spaceY;
@property (assign) float cellWidth;
@property (assign) float cellHeight;
@property (assign) Vertex *vertices;
@property (assign) int numVertices;
@property (assign) GLKVector2 originPos;

@end

@implementation EquationDraw

- (id)initWithEquation:(id<GraphDrawingProtocol>)equation minX:(float)minX maxX:(float)maxX spaceX:(float)spaceX minY:(float)minY maxY:(float)maxY spaceY:(float)spaceY cellWidth:(float)cellWidth cellHeight:(float)cellHeight effect:(GLKBaseEffect *)effect {
    self = [super init];
    
    if (self) {
        self.equation = equation;
        self.effect = effect;
        
        self.minX = minX;
        self.maxX = maxX;
        self.minY = minY;
        self.maxY = maxY;
        self.spaceX = spaceX;
        self.spaceY = spaceY;
        self.cellWidth = cellWidth;
        self.cellHeight = cellHeight;
        
        self.originPos = GLKVector2Make((-1.0 * minX * cellWidth)/spaceX, (-1.0 * minY * cellHeight)/spaceY);
        int degree;
        if ((degree = [self.equation degreeOfEquation]) == 1 || degree == 0) {
            NSLog(@"1 degree");
            self.numVertices = 2;
            self.vertices = malloc(sizeof(Vertex) * 2);
            self.vertices[0].position = [self xyPosForX:self.minX y:[self.equation yForX:self.minX]];
            self.vertices[1].position = [self xyPosForX:self.maxX y:[self.equation yForX:self.maxX]];
            self.vertices[0].color = GLKVector4Make(1.0, 0, 0, 1.0);
            self.vertices[1].color = GLKVector4Make(1.0, 0, 0, 1.0);
        } else {
            NSLog(@"%d degree", degree);
            self.numVertices = NUM_VERTICES;
            self.vertices = malloc(sizeof(Vertex) * self.numVertices);
            float step = (self.maxX - self.minX)/(float)self.numVertices;
            NSLog(@"step: %f", step);
            float start = self.minX;
            for (int i = 0; i < self.numVertices; i++) {
                self.vertices[i].position = [self xyPosForX:start y:[self.equation yForX:start]];
                self.vertices[i].color = GLKVector4Make(1.0, 0, 0, 1.0);
                start += step;
            }
        }
        
        glGenBuffers(1, &_lineBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _lineBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex) * self.numVertices, self.vertices, GL_STATIC_DRAW);
    }
    
    return self;
}

- (GLKMatrix4)modelMatrix {
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
    modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y, 0);
    return modelMatrix;
}

- (void)render {
    self.effect.transform.modelviewMatrix = self.modelMatrix;
    [self.effect prepareToDraw];
    
    glBindBuffer(GL_ARRAY_BUFFER, _lineBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *)(offsetof(Vertex, position)));
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *)(offsetof(Vertex, color)));
    glLineWidth(2.0);
    glDrawArrays(GL_LINE_STRIP, 0, self.numVertices);
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
}

- (GLKVector2)xyPosForX:(float)x y:(float)y {
    float xPos = self.originPos.x + x / self.spaceX * self.cellWidth;
    float yPos = self.originPos.y + y / self.spaceY * self.cellHeight;
    
    return GLKVector2Make(xPos, yPos);
}

@end
