//
//  ASGSnake.m
//  Snake
//
//  Created by Apple on 06.05.12.
//  Copyright (c) 2012 Anton Karamanov. All rights reserved.
//

#import "ASGSnake.h"
#import "ASGGameDirector.h"
#import "ASGRenderingDirector.h"
#import "ASGPiece.h"
#import "ASGSprite.h"

#define INITIAL_SNAKE_SIZE       4
#define INITIAL_SNAKE_POSITION_X 0
#define INITIAL_SNAKE_POSITION_Y 9
#define CRASH_PENALTY            3
#define INDULGENCE_SIZE          12
#define MIN_SIZE                 3

// render variables
#define SQUARE_SIZE 32

@implementation ASGSnake {
    snakeDirection direction;
    NSMutableArray *scales;
    BOOL canTurn;
    BOOL isReady;
    int indulgence;
}

#pragma mark - Public methods

- (ASGSnake *)initWithSize:(int)size
{
    self = [super init];
    // prevents from snake's dislocation due to the check of moving through walls
    isReady = NO;
    direction = RIGHT;
    indulgence = 0;
    // head needs to be pushed first via standart addObject function, because
    // AddScale method adds new scale based on the previous one.
    ASGPiece *headSegment = [[ASGPiece alloc] initWithX:INITIAL_SNAKE_POSITION_X 
                                               andWithY:INITIAL_SNAKE_POSITION_Y];
    scales = [[NSMutableArray alloc] initWithCapacity:size];
    [scales addObject:headSegment];
    // -1 excludes head
    for (int i = 0; i < size; i++) {
        [self addScale];
    }
    isReady = YES;
    return self;
}

- (BOOL)turnInDirection:(snakeDirection)newDirection
{
    // prevents from moving straight backwards
    BOOL turnsProperlyX = (direction >= 2 && newDirection <  2);
    BOOL turnsProperlyY = (direction <  2 && newDirection >= 2);
    if ((turnsProperlyX || turnsProperlyY) && canTurn) {
        direction = newDirection;
        // prevents from multiple turns until snake has moved
        canTurn = NO;
        return NO;
    } else {
        return YES;
    }
}

- (void)move
{
    canTurn = YES;
    // checks for crash
    if ([self hasCrashed]) {
        if (indulgence == 0) {
            indulgence = INDULGENCE_SIZE;
            [self punish];
        } else {
            indulgence -= 1;
        }
    } else {
        // if snake has stopped crashing into itself it's indulgence resets
        indulgence = 0;
    }
    // performs movement
    [self delScale];
    [self addScale];
}

- (BOOL)hasCrashed
{
    for (int i = 0; i < [scales count]; i++) {
        BOOL sameX = ((ASGPiece *)[scales lastObject]).x == ((ASGPiece *)[scales objectAtIndex:i]).x;
        BOOL sameY = ((ASGPiece *)[scales lastObject]).y == ((ASGPiece *)[scales objectAtIndex:i]).y;
        if (sameX && sameY && i != [scales count]-1) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasCaughtSnackInPositonWithX:(int)x andWithY:(int)y
{
    if (x == ((ASGPiece *)[scales lastObject]).x &&
        y == ((ASGPiece *)[scales lastObject]).y  ) {
        [self addScale];
        [self printSize];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isInPositionWithX:(int)x andWithY:(int)y
{
    for (int i = 0; i < [scales count]; i++) {
        if (x == ((ASGPiece *)[scales objectAtIndex:i]).x &&
            y == ((ASGPiece *)[scales objectAtIndex:i]).y  ) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Private methods

- (void)addScale
{
    int changeX = 0, changeY = 0;
    switch (direction) {
        case UP:
            changeY = 1;
            break;
        case RIGHT:
            changeX = 1;
            break;
        case DOWN:
            changeY = -1;
            break;
        case LEFT:
            changeX = -1;
            break;
    }
    int lastX = ((ASGPiece *)[scales lastObject]).x + changeX;
    int lastY = ((ASGPiece *)[scales lastObject]).y + changeY;
    // prevents from dislocation at creation
    if (isReady) {
        // moves snake through walls which will make it appear at the opposite wall
        if (lastX >= FIELD_WIDTH)  lastX = 0;
        if (lastY >= FIELD_HEIGHT) lastY = 0;
        if (lastX < 0) lastX = FIELD_WIDTH - 1;
        if (lastY < 0) lastY = FIELD_HEIGHT - 1;
    }
    [scales addObject:[[ASGPiece alloc] initWithX:lastX andWithY:lastY]];
}

- (void)delScale
{
    [scales removeObjectAtIndex:0]; 
}

- (void)punish
{
    for (int i = 0; i < CRASH_PENALTY; i++) {
        if ([scales count] >= MIN_SIZE + 2) {
            [self delScale];
        }
    }
    [self printSize];
}

// prints snake's size to the console
- (void)printSize
{
    NSLog(@"Snake's length is %i now.",[scales count]);
}

- (void)render
{
    for (int i = 0; i < [scales count]; i++) {
        int X = ((ASGPiece *)[scales objectAtIndex:i]).x * SQUARE_SIZE;
        int Y = ((ASGPiece *)[scales objectAtIndex:i]).y * SQUARE_SIZE;
        if (i == [scales count] - 1) {
            if ([self hasCrashed]) {
                [self drawSquareAtCoordinateWithX:X andWithY:Y andColor:dark_red];
            } else {
                [self drawSquareAtCoordinateWithX:X andWithY:Y andColor:dark_green];
            }
        } else {
            if ([self hasCrashed]) {
                [self drawSquareAtCoordinateWithX:X andWithY:Y andColor:red];
            } else {
                [self drawSquareAtCoordinateWithX:X andWithY:Y andColor:green];
            }
        }
        //[self drawSquareAtCoordinateWithX:X andWithY:Y andColor:<#(squareColor)#>];
    }
}

static const GLubyte greenV[] = {
    115, 195, 75, 255,
    115, 195, 75, 225,
    115, 195, 75, 225,
    115, 195, 75, 225
};

static const GLubyte dark_greenV[] = {
    90, 150, 60, 255,
    90, 150, 60, 255,
    90, 150, 60, 255,
    90, 150, 60, 255
};

GLubyte redV[] = {
    220, 000, 000, 255,
    220, 000, 000, 255,
    220, 000, 000, 255,
    220, 000, 000, 255
};

GLubyte dark_redV[] = {
    175, 000, 000, 255,
    175, 000, 000, 255,
    175, 000, 000, 255,
    175, 000, 000, 255
};

- (void)drawSquareAtCoordinateWithX:(int)x andWithY:(int)y andColor:(squareColor)color
{
    x = x/32;
    y = y/32;
    
    static const float hsize = 1.0f/10;
    static const float wsize = 1.0f/15;
    
    static const float hoffset = hsize/16;
    static const float woffset = wsize/16;
    
    static const GLfloat squareVertices[] = {
        0.0f + woffset,  0.0f + hoffset,
        wsize - woffset, 0.0f + hoffset,
        0.0f + woffset,  hsize - hoffset,
        wsize - woffset, hsize - hoffset
    };
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    
    
    glTranslatef(-1.0f + x * wsize, -1.0f + y * hsize, 0.0f);
    
    glVertexPointer(2, GL_FLOAT, 0, squareVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    
    switch (color) {
        case green:
            glColorPointer(4, GL_UNSIGNED_BYTE, 0, greenV);
            break;
        case dark_green:
            glColorPointer(4, GL_UNSIGNED_BYTE, 0, dark_greenV);
            break;
        case red:
            glColorPointer(4, GL_UNSIGNED_BYTE, 0, redV);
            break;
        case dark_red:
            glColorPointer(4, GL_UNSIGNED_BYTE, 0, dark_redV);
            break;
    }
    
    //glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
    glEnableClientState(GL_COLOR_ARRAY);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

@end
