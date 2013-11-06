//
//  ASGSprite.h
//  Snake
//
//  Created by Apple on 06.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface ASGSprite : NSObject

@property (assign) GLKVector2 position;
@property (assign) CGSize contentSize;

- (id)initWithFile:(NSString *)filePath effect:(GLKBaseEffect *)effect;
- (void)render;

@end
