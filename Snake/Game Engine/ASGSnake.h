//
//  ASGSnake.h
//  Snake
//
//  Created by Apple on 06.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASGSnake : NSObject

typedef enum snakeDirection {UP, DOWN, RIGHT, LEFT, NONE} snakeDirection;

/* Constructors */
- (ASGSnake *)initWithSize:(int)size;

/* Methods */
- (BOOL)turnInDirection:(snakeDirection)newDirection;
- (void)move;

- (BOOL)hasCrashed;
- (BOOL)hasCaughtSnackInPositonWithX:(int)x andWithY:(int)y;
- (BOOL)isInPositionWithX:(int)x andWithY:(int)y;

- (void)render;

@end