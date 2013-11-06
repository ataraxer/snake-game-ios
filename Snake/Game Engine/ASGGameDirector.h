//
//  ASGGameDirector.h
//  Snake
//
//  Created by Apple on 07.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASGSnake.h"
#import "ASGFood.h"

#define SNACKS_LIMIT 1
#define FIELD_WIDTH  30
#define FIELD_HEIGHT 20 

@interface ASGGameDirector : NSObject

+ (void)gdStart;
+ (BOOL)gdIsActive;
+ (void)gdProcess;
+ (void)gdMoveSnakeThroughWallInCoordinateWithX:(int)x andWithY:(int)y;
+ (void)gdTurnSnakeInDirection:(snakeDirection)newDirection;
+ (void)gdRender;
+ (void)gdPause;

@end