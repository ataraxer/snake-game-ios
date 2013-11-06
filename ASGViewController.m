//
//  ASGViewController.m
//  Snake
//
//  Created by Apple on 06.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASGViewController.h"
#import "ASGGameDirector.h"
#import "ASGRenderingDirector.h"
#import "ASGFood.h"
#import "ASGSprite.h"

@interface ASGViewController () {
    UIAccelerometer *accelerometer;
    float lastX;
    float lastY;
    float lastZ;
    CGPoint gestureStartPoint;
    snakeDirection direction;
    
    int rdFrame;
    float rdAngle;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong) GLKBaseEffect *effect;
@property (strong) ASGSprite *player;

@property (nonatomic, retain) UIAccelerometer *accelerometer;

@end

@implementation ASGViewController
@synthesize context = _context;
@synthesize effect = _effect;
@synthesize player = _player;

@synthesize accelerometer = _accelerometer;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    gestureStartPoint = [touch locationInView:self.view];
    
    if ([touches count] == 2) {
        [ASGGameDirector gdPause];
        return;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self.view];
    
    CGFloat deltaX = gestureStartPoint.x - currentPosition.x;
    CGFloat deltaY = gestureStartPoint.y - currentPosition.y;
    
    NSLog(@"deltas are %f, %f", currentPosition.x, currentPosition.y);
    
    /*
    if (deltaY < 10) {
        if (deltaX >= 50) {
            [ASGGameDirector gdTurnSnakeInDirection:LEFT];
        } else {
            [ASGGameDirector gdTurnSnakeInDirection:RIGHT];
        }
    }
    
    if (deltaX < 10) {
        if (deltaY >= 50) {
            [ASGGameDirector gdTurnSnakeInDirection:DOWN];
        } else {
            [ASGGameDirector gdTurnSnakeInDirection:UP];
        }
    }
    */
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self.view];

    if ([touches count] == 2) {
        return;
    }
    
    if (direction == RIGHT || direction == LEFT) {
        if (currentPosition.y < 155.0f) {
            [ASGGameDirector gdTurnSnakeInDirection:UP];
            direction = UP;
        } else {
            [ASGGameDirector gdTurnSnakeInDirection:DOWN];
            direction = DOWN;
        }
    } else {
        if (currentPosition.x > 237.5f) {
            [ASGGameDirector gdTurnSnakeInDirection:RIGHT];
            direction = RIGHT;
        } else {
            [ASGGameDirector gdTurnSnakeInDirection:LEFT];
            direction = LEFT;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    [EAGLContext setCurrentContext:self.context];
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, 960, 0, 640, -1024, 1024);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    [ASGGameDirector gdStart];
    
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.updateInterval = .1;
    self.accelerometer.delegate = self;
    
    lastX = 0.0f;
    lastY = 0.0f;
    lastZ = 0.0f;
    
    direction = RIGHT;
    
    rdFrame = 0;
    rdAngle = 0.0f;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    /*
    if (ABS(acceleration.x - lastX) > 0.2f) {
        if (acceleration.x - lastX > 0) {
            [ASGGameDirector gdTurnSnakeInDirection:UP];
        } else {
            [ASGGameDirector gdTurnSnakeInDirection:DOWN];
        }
    } else {
        if (ABS(acceleration.y - lastY) > 0.2f) {
            if (acceleration.y - lastY > 0) {
                [ASGGameDirector gdTurnSnakeInDirection:LEFT];
            } else {
                [ASGGameDirector gdTurnSnakeInDirection:RIGHT];
            }
        }
    }
    */
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect 
{    
    glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    [ASGGameDirector gdRender];
}

- (void)update
{
    if (rdFrame == 60) {
        rdFrame = 0;
    }
    rdFrame++;
    rdAngle += PI/30;
    
    [ASGRenderingDirector setAngle:rdAngle];
    
    if (rdFrame%5 == 0) {
        [ASGGameDirector gdProcess];
    }
    rdFrame++;
}

@end