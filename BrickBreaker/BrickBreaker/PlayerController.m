//
//  PlayerController.m
//  Gunnit
//
//  Created by Carl D on 10/6/13.
//  Copyright (c) 2013 Student. All rights reserved.
//

#import "PlayerController.h"

static const int X_OFFSET = 20;

@implementation PlayerController
{
    // holds the speed of the player
    float _speed;
    
    // the view for the object
    UIView *_view;
    
    // the box the player is bound to
    CGRect _boundary;
    
    // the position to put the player back to
    CGPoint _pos;
}

-(id) initWithView:(UIView *)player Boundary:(CGRect)rect
{
    self = [super init];
    if(self)
    {
        // Custom Initialization
        
        // set the view to the UIView
        _view = player;
        
        // create the boundary for the player
        _boundary = rect;
    }
    // set the speed for the player
    _speed = 10;
    return self;
}

-(void) reset
{
    // unhide the player
    _view.hidden = NO;
    
    // find the center of the boundary to store for reset
    _pos.x = _boundary.origin.x + _boundary.size.width / 2;
    _pos.y = _boundary.origin.y + _boundary.size.height / 2;
    
    // move the player back to the center
    _view.center = _pos;
}

// move player on the screen
-(void)move:(float)dx
{
    // value to put player at
    float x;
    
    // if the player's x is less than the boundary plus the offset
    // then set the player's x to the boundary plus the offset
    if(_view.center.x < _boundary.origin.x + X_OFFSET)
        x = _boundary.origin.x + X_OFFSET;
    
    // else if the player's x is greater than the boundary's width minus the offset
    // then set the player's x to the boundary's width minus the offset
    else if(_view.center.x > _boundary.origin.x + _boundary.size.width - X_OFFSET)
        x = _boundary.origin.x + _boundary.size.width - X_OFFSET;
    
    // else move the player as you normally would
    else
        x = _view.center.x + dx * _speed;
    
    // the y doesnt change at all
    float y = _view.center.y + 0 * _speed;
    
    // move the player to the point
    _view.center = CGPointMake(x,y);
}


// Center point of paddle
-(CGPoint)center
{
    return _view.center;
}

// check if the paddle intersects with the rectangle
-(BOOL) intersects:(CGRect)rect
{
    return CGRectIntersectsRect(_view.frame, rect);
}

@end
