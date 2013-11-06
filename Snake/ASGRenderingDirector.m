//
//  ASGRenderingDirector.m
//  Snake
//
//  Created by Apple on 08.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ASGRenderingDirector.h"
#import "ASGGameDirector.h"

@implementation ASGRenderingDirector

float rdAngle;

+ (void)setAngle:(float)angle
{
    rdAngle = angle;
}

+ (float)rdOpacityWithModifier:(float)modifier
{
    if ([ASGGameDirector gdIsActive]) {
        return (sin(rdAngle * modifier + 3*PI/2) + 1)/2;
    } else {
        return 1.0f;
    }
}

@end