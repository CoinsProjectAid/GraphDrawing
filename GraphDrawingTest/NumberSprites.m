//
//  NumberSprites.m
//  GraphDrawingTest
//
//  Created by Yuki Fujiyama on 2014/02/12.
//  Copyright (c) 2014年 Yuki Fujiyama. All rights reserved.
//

#import "NumberSprites.h"

@interface NumberSprites ()

@property (strong, nonatomic) NSMutableArray *sprites;
@property (strong, nonatomic) GLKBaseEffect *effect;

@end

@implementation NumberSprites

static NumberSprites *numberSprites;

- (id)initWithEffect:(GLKBaseEffect *)effect {
    self = [super init];
    if (self) {
        self.effect = effect;
        
        self.sprites = [NSMutableArray array];
        
        for (int i = 0; i <= 9; i++) {
            MySprite *sprite = [[MySprite alloc] initWithFile:[NSString stringWithFormat:@"nn%d.png", i] effect:self.effect];
            [self.sprites addObject:sprite];
        }
        
        [self.sprites addObject:[[MySprite alloc] initWithFile:@"nnDot.png" effect:self.effect]];
        [self.sprites addObject:[[MySprite alloc] initWithFile:@"nnMinus.png" effect:self.effect]];
    }
    return self;
}

+ (NumberSprites *)numberSpritesWithEffect:(GLKBaseEffect *)effect {
    if (numberSprites == nil) {
        numberSprites = [[NumberSprites alloc] initWithEffect:effect];
    }
    return numberSprites;
}

- (MySprite *)number:(int)value {
    MySprite *sprite = [numberSprites.sprites objectAtIndex:value];
    return [sprite copy];
}

@end
