//
//  Dot.m
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/04.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import "Dot.h"

#define DEGREE_TO_RADIAN(x) (3.14159265358979323 * (x) / 180.0)
#define DOT_SIZE 3.0

typedef struct {
    GLKVector2 position;
    GLKVector4 color;
} Vertex;

typedef struct {
    Vertex vertices[360];
} Circle;

@interface Dot () {
    GLuint _circleBuffer;
}

@property (strong) GLKBaseEffect *effect;
@property (assign) Circle circle;

@end

@implementation Dot

- (id)initWithEffect:(GLKBaseEffect *)effect {
    self = [super init];
    if (self) {
        self.effect = effect;
        
        for (int i = 0; i < 360; i++) {
            _circle.vertices[i].position = GLKVector2Make(cos(DEGREE_TO_RADIAN(i)) * DOT_SIZE, sin(DEGREE_TO_RADIAN(i)) * DOT_SIZE);
            _circle.vertices[i].color = GLKVector4Make(1, 0, 0, 1);
        }
        
        glGenBuffers(1, &_circleBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _circleBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Circle), &_circle, GL_STATIC_DRAW);
    }
    return self;
}

- (void)render {
    self.effect.transform.modelviewMatrix = self.modelMatrix;
    [self.effect prepareToDraw];
    
    glBindBuffer(GL_ARRAY_BUFFER, _circleBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *)(offsetof(Circle, vertices[0]) + offsetof(Vertex, position)));
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *)(offsetof(Circle, vertices[0]) + offsetof(Vertex, color)));
    glDrawArrays(GL_TRIANGLE_FAN, 0, 360);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
}

- (GLKMatrix4)modelMatrix {
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
    //NSLog(@"position x: %f y: %f", self.position.x, self.position.y);
    modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y, 0);
    return modelMatrix;
}

- (id)copyWithZone:(NSZone *)zone {
    Dot *copyDot = [[[self class] allocWithZone:zone] init];
    
    if (copyDot) {
        copyDot->_circleBuffer = _circleBuffer;
        copyDot->_effect = _effect;
    }
    return copyDot;
}

@end
