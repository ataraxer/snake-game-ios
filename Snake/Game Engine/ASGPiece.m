//
//  ASGPiece.m
//  Snake
//
//  Created by Apple on 06.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ASGPiece.h"

@implementation ASGPiece

@synthesize x;
@synthesize y;

- (ASGPiece *)initWithX:(int)inX andWithY:(int)inY
{
    self = [super init];
    self.x = inX;
    self.y = inY;
    return self;
}

@end
