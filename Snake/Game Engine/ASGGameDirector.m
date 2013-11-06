//
//  ASGGameDirector.m
//  Snake
//
//  Created by Apple on 07.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ASGGameDirector.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation ASGGameDirector

ASGSnake *python;
NSMutableArray *snacks;
BOOL isActive;
SystemSoundID popSound;
NSString *popSoundPath;

+ (void)gdStart
{
    isActive = YES;
    python = [[ASGSnake alloc] initWithSize:3];
    snacks = [[NSMutableArray alloc] init];
    [self gdAddSnackWithFoodType:NORMAL];
    popSoundPath = [[NSBundle mainBundle] pathForResource:@"pop" ofType:@"mp3"];
    NSURL *pathURL = [NSURL fileURLWithPath:popSoundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pathURL, &popSound);
}

+ (BOOL)gdIsActive
{
    return isActive;
}

+ (void)gdProcess
{
    if (isActive) {
        // prevents snake from speeding up after catching snack
        BOOL isHungry = YES;
        // checks if snake has collected the food
        for (int i = 0; i < [snacks count]; i++) {
            int X = [((ASGFood *)[snacks objectAtIndex:i]) getX];
            int Y = [((ASGFood *)[snacks objectAtIndex:i]) getY];
            if ([python hasCaughtSnackInPositonWithX:X 
                                            andWithY:Y]) {
                //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                AudioServicesPlaySystemSound(popSound);
                [snacks removeObjectAtIndex:i];
                isHungry = NO;
            }
        }
        // adds food
        if ([snacks count] < SNACKS_LIMIT) {
            [self gdAddSnackWithFoodType:NORMAL];
        }
        // moves snake
        if (isHungry) {
            [python move];
        }
    }
}

+ (void)gdPause
{
    isActive = !isActive;
    if (isActive) {
        NSLog(@"Unpaused");
    } else {
        NSLog(@"Paused");
    }
}

+ (void)gdTurnSnakeInDirection:(snakeDirection)newDirection
{
    // prevents from turning while paused
    if (isActive) {
        [python turnInDirection:newDirection];
    }
}

+ (void)gdAddSnackWithFoodType:(foodType)inType
{
    int foodX, foodY;
    // prevents from appearing inside the snake
    do {
        foodX = arc4random() % FIELD_WIDTH;
        foodY = arc4random() % FIELD_HEIGHT;
    } while ([python isInPositionWithX:foodX 
                              andWithY:foodY]);
    [snacks addObject:[[ASGFood alloc] initWithCoordinateWithX:foodX
                                                      andWithY:foodY
                                                       andType:NORMAL]];
}

+ (void)gdRender
{
    if (python == nil) {
        python = [[ASGSnake alloc] initWithSize:5];
    }
    [python render];
    for (ASGFood *snack in snacks) {
        [snack render];
    }
}

@end
