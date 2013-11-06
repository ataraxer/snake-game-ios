//
//  ASGFood.m
//  Snake
//
//  Created by Apple on 07.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ASGFood.h"
#import "ASGRenderingDirector.h"
#import <GLKit/GLKit.h>

@implementation ASGFood

@synthesize coordinate;
@synthesize type;

- (int)getX
{
    return coordinate.x;
}

- (int)getY
{
    return coordinate.y;
}

- (ASGFood *)initWithCoordinateWithX:(int)x andWithY:(int)y andType:(foodType)inType {
    self = [super init];
    self.coordinate = [[ASGPiece alloc] initWithX:x andWithY:y];
    self.type = inType;
    return self;
}

- (ASGFood *)initWithCoordinate:(ASGPiece *)inCoordinate andType:(foodType)inType
{
    self = [super init];
    self.coordinate = inCoordinate;
    self.type = inType;
    return self;
}

- (void)render
{
    int x = coordinate.x;
    int y = coordinate.y;
    
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
    
    float opacity = [ASGRenderingDirector rdOpacityWithModifier:1.0f];
    
    int alpha = 255*opacity;
    
    GLubyte squareColors[] = {
        40, 115, 220, alpha,
        40, 115, 220, alpha,
        40, 115, 220, alpha,
        40, 115, 220, alpha
    };
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glTranslatef(-1.0f + x * wsize, -1.0f + y * hsize, 0.0f);
    
    glVertexPointer(2, GL_FLOAT, 0, squareVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
    glEnableClientState(GL_COLOR_ARRAY);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

@end
