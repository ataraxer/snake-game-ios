//
//  ASGPiece.h
//  Snake
//
//  Created by Apple on 06.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASGPiece : NSObject

- (ASGPiece *)initWithX:(int)x andWithY:(int)y;

@property (nonatomic, assign) int x;
@property (nonatomic, assign) int y;

@end
