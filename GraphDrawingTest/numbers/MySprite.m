//
//  MySprite.m
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/04.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import "MySprite.h"

typedef struct {
    CGPoint geometryVertex;
    CGPoint textureVertex;
} TexturedVertex;

typedef struct {
    TexturedVertex bl;
    TexturedVertex br;
    TexturedVertex tl;
    TexturedVertex tr;
} TexturedQuad;

@interface MySprite () {
    GLuint _spriteBuffer;
}

@property (strong) GLKBaseEffect *effect;
@property (assign) TexturedQuad quad;
@property (strong) GLKTextureInfo *textureInfo;

@end


@implementation MySprite

- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect value:(int)value {
    if ((self = [super init]) != nil) {
        self.effect = effect;
        self.value = value;
        self.scale = 1.0;
        
        //self.effect2 = [[GLKBaseEffect alloc] init];
        //self.effect2.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, 1024, 0, 768, 0, 0);
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES],
                                 GLKTextureLoaderOriginBottomLeft, nil];
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        
        self.textureInfo = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
        if (self.textureInfo == nil) {
            NSLog(@"Error loading fil: %@", [error localizedDescription]);
        }
        
        _contentSize = CGSizeMake(self.textureInfo.width, self.textureInfo.height);
        
        TexturedQuad newQuad;
        newQuad.bl.geometryVertex = CGPointMake(0, 0);
        newQuad.br.geometryVertex = CGPointMake(self.contentSize.width, 0);
        newQuad.tl.geometryVertex = CGPointMake(0, self.contentSize.height);
        newQuad.tr.geometryVertex = CGPointMake(self.contentSize.width, self.contentSize.height);
        
        newQuad.bl.textureVertex = CGPointMake(0, 0);
        newQuad.br.textureVertex = CGPointMake(1, 0);
        newQuad.tl.textureVertex = CGPointMake(0, 1);
        newQuad.tr.textureVertex = CGPointMake(1, 1);
        
        self.quad = newQuad;
        
        glGenBuffers(1, &_spriteBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _spriteBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(TexturedQuad), &_quad, GL_STATIC_DRAW);
        
    }
    
    return self;
}

- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect {
    if ((self = [super init]) != nil) {
        self.effect = effect;
        self.value = 0;
        self.scale = 1.0;
        
        //self.effect2 = [[GLKBaseEffect alloc] init];
        //self.effect2.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, 1024, 0, 768, 0, 0);
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES],
                                 GLKTextureLoaderOriginBottomLeft, nil];
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        
        self.textureInfo = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
        if (self.textureInfo == nil) {
            NSLog(@"Error loading fil: %@", [error localizedDescription]);
        }
        
        _contentSize = CGSizeMake(self.textureInfo.width, self.textureInfo.height);
        
        TexturedQuad newQuad;
        newQuad.bl.geometryVertex = CGPointMake(0, 0);
        newQuad.br.geometryVertex = CGPointMake(self.contentSize.width, 0);
        newQuad.tl.geometryVertex = CGPointMake(0, self.contentSize.height);
        newQuad.tr.geometryVertex = CGPointMake(self.contentSize.width, self.contentSize.height);
        
        newQuad.bl.textureVertex = CGPointMake(0, 0);
        newQuad.br.textureVertex = CGPointMake(1, 0);
        newQuad.tl.textureVertex = CGPointMake(0, 1);
        newQuad.tr.textureVertex = CGPointMake(1, 1);
        
        self.quad = newQuad;
        
        glGenBuffers(1, &_spriteBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _spriteBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(TexturedQuad), &_quad, GL_STATIC_DRAW);
        
    }
    
    return self;
}


- (GLKMatrix4) modelMatrix {
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
    modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x - self.contentSize.width/2, self.position.y - self.contentSize.height/2, 0);
    modelMatrix = GLKMatrix4Scale(modelMatrix, self.scale, self.scale, 0);
    
    return modelMatrix;
}

- (void)render {
    self.effect.texture2d0.name = self.textureInfo.name;
    self.effect.texture2d0.enabled = YES;
    self.effect.texture2d0.envMode = GLKTextureEnvModeModulate;
    
    self.effect.transform.modelviewMatrix = self.modelMatrix;
    
    [self.effect prepareToDraw];
    
    
    glBindBuffer(GL_ARRAY_BUFFER, _spriteBuffer);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *)(offsetof(TexturedVertex, geometryVertex)));
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *)(offsetof(TexturedVertex, textureVertex)));
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
}

- (id)copyWithZone:(NSZone *)zone {
    MySprite *tmpcopy = [[[self class] allocWithZone:zone] init];
    
    if (tmpcopy) {
        tmpcopy->_effect = [[GLKBaseEffect alloc] init];
        tmpcopy->_effect.transform.projectionMatrix = self.effect.transform.projectionMatrix;
        tmpcopy->_quad = _quad;
        tmpcopy->_value = _value;
        tmpcopy->_textureInfo = _textureInfo;
        tmpcopy->_contentSize = _contentSize;
        tmpcopy->_position = _position;
        tmpcopy->_spriteBuffer = _spriteBuffer;
    }
    return tmpcopy;
}


@end
