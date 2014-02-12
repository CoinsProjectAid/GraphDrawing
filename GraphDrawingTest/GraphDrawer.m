//
//  GraphDrawer.m
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/03.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import "GraphDrawer.h"
#import "Dot.h"
#import "MyPoint.h"
#import "MyEquation.h"

#define ALLOWED_GOSA 0.3    //0.1 ~ 0.5

typedef struct {
    GLKVector2 position;
    GLKVector4 color;
} Vertex;

typedef struct {
    Vertex vertices[500];
} LinePoints;

typedef struct {
    Vertex vertices[2];
} Line;

@interface GraphDrawer () {
    GLuint _xLinesBuffer;
    GLuint _yLinesBuffer;
    GLuint _originLinesBuffer;
}

//@property (strong, nonatomic) GLKBaseEffect *effect;
@property (assign) LinePoints linePoints;
@property (assign) Line *xLines;
@property (assign) Line *yLines;
@property (assign) Line *originLines;
@property (assign) double startX;
@property (assign) double startY;
@property (assign) double endX;
@property (assign) double endY;
@property (assign) double spaceX;
@property (assign) double spaceY;
@property (assign) GLKVector2 origin;
@property (strong) NSMutableArray *dots;
@property (strong) NSMutableArray *points;
@property (strong) MyEquation *equation;

@property (strong) Dot *dot;

@end

@implementation GraphDrawer

- (id)initWithRows:(int)rows columns:(int)columns effect:(GLKBaseEffect *)effect {
    self = [super init];
    
    if (self) {
        self.effect = effect;
        
        self.position = GLKVector2Make(0, 0);
        
        self.dots = [NSMutableArray array];
        self.points = [NSMutableArray array];
        
        self.numVertical = columns;
        self.numHorizontal = rows;
        
        _xLines = (Line *)malloc(sizeof(Line) * _numVertical + sizeof(Line));
        _yLines = (Line *)malloc(sizeof(Line) * _numHorizontal + sizeof(Line));
        
        double width = GRAPH_SIZE/_numVertical;
        double height = GRAPH_SIZE/_numHorizontal;
        
        
        for (int i = 0; i < _numVertical + 1; i++) {
            _xLines[i].vertices[0].position = GLKVector2Make(i*width, 0.0);
            _xLines[i].vertices[1].position = GLKVector2Make(i*width, GRAPH_SIZE);
            _xLines[i].vertices[0].color = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
            _xLines[i].vertices[1].color = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
        }
        
        for (int i = 0; i < _numHorizontal + 1; i++) {
            _yLines[i].vertices[0].position = GLKVector2Make(0.0, i*height);
            _yLines[i].vertices[1].position = GLKVector2Make(GRAPH_SIZE, i*height);
            _yLines[i].vertices[0].color = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
            _yLines[i].vertices[1].color = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
        }
        
        glGenBuffers(1, &_xLinesBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _xLinesBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Line) * _numVertical + sizeof(Line), _xLines, GL_STATIC_DRAW);
    
        glGenBuffers(1, &_yLinesBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _yLinesBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Line) * _numHorizontal + sizeof(Line), _yLines, GL_STATIC_DRAW);
    }
    
    return self;
}

- (id)initWithStartX:(double)startX endX:(double)endX spaceX:(double)spaceX startY:(double)startY endY:(double)endY spaceY:(double)spaceY effect:(GLKBaseEffect *)effect {
    self = [super init];
    
    if (self) {
        self.effect = effect;
        
        _dot = [[Dot alloc] initWithEffect: self.effect]; //test
        
        self.position = GLKVector2Make(0, 0);
        
        self.dots = [NSMutableArray array];
        
        if (startX > endX) {
            _startX = endX;
            _endX = startX;
        } else {
            _startX = startX;
            _endX = endX;
        }
        
        if (startY > endY) {
            _startY = endY;
            _endY = startY;
        } else {
            _startY = startY;
            _endY = endY;
        }
        
        _spaceX = spaceX;
        _spaceY = spaceY;
        
        self.origin = GLKVector2Make(-_startX/_spaceX, -_startY/_spaceY);
        
        self.numVertical = (self.endX - self.startX)/_spaceX;
        self.numHorizontal = (self.endY - self.startY)/_spaceY;
        
        _xLines = (Line *)malloc(sizeof(Line) * _numVertical + sizeof(Line));
        _yLines = (Line *)malloc(sizeof(Line) * _numHorizontal + sizeof(Line));
        
        _originLines = (Line *)malloc(sizeof(Line) * 2);
        
        self.width = GRAPH_SIZE/_numVertical;
        self.height = GRAPH_SIZE/_numHorizontal;
        
        
        for (int i = 0; i < _numVertical + 1; i++) {
            _xLines[i].vertices[0].position = GLKVector2Make(i*_width, 0.0);
            _xLines[i].vertices[1].position = GLKVector2Make(i*_width, GRAPH_SIZE);
            if (i == self.origin.x) {
                _xLines[i].vertices[0].color = GLKVector4Make(0, 0, 0, 1.0);
                _xLines[i].vertices[1].color = GLKVector4Make(0, 0, 0, 1.0);
            } else {
                _xLines[i].vertices[0].color = GLKVector4Make(0, 0, 1.0, 1.0);
                _xLines[i].vertices[1].color = GLKVector4Make(0, 0, 1.0, 1.0);
            }
        }
        
        for (int i = 0; i < _numHorizontal + 1; i++) {
            _yLines[i].vertices[0].position = GLKVector2Make(0.0, i*_height);
            _yLines[i].vertices[1].position = GLKVector2Make(GRAPH_SIZE, i*_height);
            if (i == self.origin.y) {
                _yLines[i].vertices[0].color = GLKVector4Make(0, 0, 0, 1.0);
                _yLines[i].vertices[1].color = GLKVector4Make(0, 0, 0, 1.0);
            } else {
                _yLines[i].vertices[0].color = GLKVector4Make(0, 0, 1.0, 1.0);
                _yLines[i].vertices[1].color = GLKVector4Make(0, 0, 1.0, 1.0);
            }
        }
        
        _originLines[0].vertices[0].position = GLKVector2Make(_origin.x * _width, 0);
        _originLines[0].vertices[1].position = GLKVector2Make(_origin.x * _width, GRAPH_SIZE);
        _originLines[0].vertices[0].color = GLKVector4Make(0, 0, 0, 1.0);
        _originLines[0].vertices[1].color = GLKVector4Make(0, 0, 0, 1.0);
        
        _originLines[1].vertices[0].position = GLKVector2Make(0, _origin.y * _height);
        _originLines[1].vertices[1].position = GLKVector2Make(GRAPH_SIZE, _origin.y * _height);
        _originLines[1].vertices[0].color = GLKVector4Make(0, 0, 0, 1.0);
        _originLines[1].vertices[1].color = GLKVector4Make(0, 0, 0, 1.0);
        
        glGenBuffers(1, &_originLinesBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _originLinesBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Line) * 2, _originLines, GL_STATIC_DRAW);
        
        glGenBuffers(1, &_xLinesBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _xLinesBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Line) * _numVertical + sizeof(Line), _xLines, GL_STATIC_DRAW);
        
        glGenBuffers(1, &_yLinesBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _yLinesBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Line) * _numHorizontal + sizeof(Line), _yLines, GL_STATIC_DRAW);
    }
    
    return self;
}

- (void)render {
    self.effect.transform.modelviewMatrix = self.modelView;
    [self.effect prepareToDraw];
    
    glLineWidth(1);
    glBindBuffer(GL_ARRAY_BUFFER, _xLinesBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *)(offsetof(Line, vertices[0]) + offsetof(Vertex, position)));
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *)(offsetof(Line, vertices[0]) + offsetof(Vertex, color)));
    glDrawArrays(GL_LINES, 0, _numVertical*2 + 2);
    
    glBindBuffer(GL_ARRAY_BUFFER, _yLinesBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *)(offsetof(Line, vertices[0]) + offsetof(Vertex, position)));
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *)(offsetof(Line, vertices[0]) + offsetof(Vertex, color)));
    glDrawArrays(GL_LINES, 0, _numHorizontal*2 + 2);
    
    glBindBuffer(GL_ARRAY_BUFFER, _originLinesBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *)(offsetof(Line, vertices[0]) + offsetof(Vertex, position)));
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *)(offsetof(Line, vertices[0]) + offsetof(Vertex, color)));
    glLineWidth(4);
    glDrawArrays(GL_LINES, 0, 4);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
    
    for (Dot *dot in self.dots) {
        [dot render];
    }
}

- (GLKMatrix4)modelView {
    GLKMatrix4 modelView = GLKMatrix4Identity;
    modelView = GLKMatrix4Translate(modelView, self.position.x, self.position.y, 0);
    return modelView;
}

- (void)choosePoint:(GLKVector2)pointLocation {
    double tmpX = (pointLocation.x - self.position.x)/self.width;
    int pointX;
    if (tmpX - (int)tmpX >= 0.5) {
        pointX = tmpX + 1;
    } else {
        pointX = tmpX;
    }
    double tmpY = (pointLocation.y - self.position.y)/self.height;
    int pointY;
    if (tmpY - (int)tmpY >= 0.5) {
        pointY = tmpY + 1;
    } else {
        pointY = tmpY;
    }
    
    Dot *dot = [[Dot alloc] initWithEffect: self.effect];
    dot.position = GLKVector2Make(pointX * _width + self.position.x, pointY * _height + self.position.y);
    pointX -= self.origin.x;
    pointY -= self.origin.y;
    dot.point = GLKVector2Make(pointX*_spaceX, pointY*_spaceY);
    
    [self.dots addObject:dot];
    
    NSLog(@"Chosen Point x: %f y: %f", pointX*_spaceX, pointY*_spaceY);
}

- (BOOL)choosePoint2:(GLKVector2)pointLocation {
    double tmpX = (pointLocation.x - self.position.x)/self.width;
    int pointX;
    if (tmpX - (int)tmpX >= 1.0 - ALLOWED_GOSA) {
        pointX = tmpX + 1;
    } else if (tmpX - (int)tmpX <= ALLOWED_GOSA) {
        pointX = tmpX;
    } else {
        return NO;
    }
    double tmpY = (pointLocation.y - self.position.y)/self.height;
    int pointY;
    if (tmpY - (int)tmpY >= 1.0 - ALLOWED_GOSA) {
        pointY = tmpY + 1;
    } else if (tmpY - (int)tmpY <= ALLOWED_GOSA) {
        pointY = tmpY;
    } else {
        return NO;
    }
    
    //Dot *dot = [[Dot alloc] initWithEffect: self.effect];
    Dot *dot = [self.dot copy];
    dot.position = GLKVector2Make(pointX * _width + self.position.x, pointY * _height + self.position.y);
    pointX -= self.origin.x;
    pointY -= self.origin.y;
    dot.point = GLKVector2Make(pointX*_spaceX, pointY*_spaceY);
    BOOL alreadyExist = NO;
    
    for (Dot *otherDot in self.dots) {
        if (GLKVector2AllEqualToVector2(otherDot.point, dot.point)) {
            [self.dots removeObject:otherDot];
            alreadyExist = YES;
            break;
        }
    }

    if (!alreadyExist) {
        [self.dots addObject:dot];
    }
    
    NSLog(@"Chosen Point x: %f y: %f", pointX*_spaceX, pointY*_spaceY);
    
    return YES;
}

- (BOOL)checkPoints {
    for (Dot *dot in self.dots) {
        if (dot.point.y != [self.equation yForX:dot.point.x]) {
            return NO;
        }
    }
    return YES;
}

- (void)dealloc {
    free(_xLines);
    free(_yLines);
}

@end
