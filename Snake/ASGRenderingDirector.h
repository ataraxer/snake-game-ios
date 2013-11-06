//
//  ASGRenderingDirector.h
//  Snake
//
//  Created by Apple on 08.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define PI 3.14159265358979323846f

typedef enum squareColor {green, dark_green, red, dark_red, blue} squareColor;

@interface ASGRenderingDirector : NSObject

+ (void)setAngle:(float)angle;
+ (float)rdOpacityWithModifier:(float)modifier;

@end
