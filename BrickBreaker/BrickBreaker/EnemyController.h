//
//  EnemyController.h
//  Gunnit
//
//  Created by Carl D on 10/7/13.
//  Copyright (c) 2013 Student. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnemyController : NSObject

// enemies health
@property (readonly) int health;

// max width and height for the enemy
@property (readonly) float maxHeight;
@property (readonly) float maxWidth;

// bool to see if the enemy is dead
@property (readonly) BOOL dead;

// the view that the enemy will have
@property (readonly) UIView *view;

//initialize the enemy
-(id) initWithView: (UIView *) enemy
         maxHeight:(float)height
          maxWidth:(float)width;

// decrease enemy health
-(void)loseHealth;

// check if the enemy is dead
-(BOOL)dead;

// animate the enemy
-(void)animate;

// get bounding box of enemy
-(CGRect)frame;

// center of the enemy
-(CGPoint)center;

// check if the enemy intersects with the rectangle
-(BOOL)intersects:(CGRect)rect;

// reset the enemy
-(void)reset;

@end
