//
//  EnemyController.m
//  Gunnit
//
//  Created by Carl D on 10/7/13.
//  Copyright (c) 2013 Student. All rights reserved.
//

#import "EnemyController.h"

static const int X_OFFSET = 20;

static const int Y_OFFSET = 125;

static const int RAND_SPEED = 3;

@implementation EnemyController
{
    // the x position for the enemy
    float _posX;
    
    // the y position for the enemy;
    float _posY;
    
    // the speed that they'll move at
    float _speed;
}

// initializer
-(id) initWithView: (UIView*) enemy
         maxHeight:(float)height
          maxWidth:(float)width{
    self = [super init];
    if (self){
        // view takes the UIView
        _view = enemy;
        
        // health is set to 1
        _health = 1;
        
        // the max height is the set height
        _maxHeight = height;
        
        // the max width is the set width
        _maxWidth = width;
        
        // the enemy is not dead
        _dead = false;
        
        // the enemy gets a random speed
        _speed = arc4random_uniform(RAND_SPEED) + 1;
    }
    return self;
}

// the bounding box of the enemy
-(CGRect)frame
{
    return  _view.frame;
}

// center of the enemy
-(CGPoint)center
{
    return _view.center;
}

// make the enemy lose health
-(void) loseHealth
{
    if(_health <= 0) _dead = YES;
    else
    {
        _health--;
        
        // for feedback
        _view.alpha -= 0.50;
    }
}

// move the enemy vertically
-(void)animate
{
    _view.hidden = NO;
    
    // get the current x and y
    _posX = self.center.x;
    _posY = self.center.y;
    
    // update the y
    _posY += _speed;
    
    // create the new position
    _view.center = CGPointMake(_posX, _posY);
    
    // if the enemy moves off screen then reset
    if(_view.center.y > _maxHeight)
    {
        [self reset];
    }
}

// check if the enemy intersects with the rectangle
-(BOOL) intersects:(CGRect)rect
{
    return CGRectIntersectsRect(_view.frame, rect);
}

-(void)reset
{
    // give it a new speed
    _speed = arc4random_uniform(RAND_SPEED) + 1;
    
    // reset it's health
    _health = 1;
    
    // make it visible again
    _view.alpha = 1;
    
    // it isnt dead
    _dead = false;
    
    // give it a random x position
    _posX = arc4random_uniform(_maxWidth);
    if (_posX < X_OFFSET)
    {
        _posX += X_OFFSET;
    }
    else if (_posX > _maxWidth - X_OFFSET)
    {
        _posX -= X_OFFSET;
    }
    
    // give it a random y position off screen
    _posY = arc4random_uniform(75);
    _posY -= Y_OFFSET;
    
    // give the view that position
    _view.center = CGPointMake(_posX, _posY);
}

@end
