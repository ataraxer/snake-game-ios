//
//  ASGFood.h
//  Snake
//
//  Created by Apple on 07.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASGPiece.h"

typedef enum foodType {NORMAL} foodType;

@interface ASGFood : NSObject

@property (nonatomic, strong) ASGPiece *coordinate;
@property (nonatomic, assign) foodType type;

- (ASGFood *)initWithCoordinateWithX:(int)x andWithY:(int)y andType:(foodType)inType;
- (ASGFood *)initWithCoordinate:(ASGPiece *)inCoordinate andType:(foodType)inType;
- (int)getX;
- (int)getY;

- (void)render;

@end