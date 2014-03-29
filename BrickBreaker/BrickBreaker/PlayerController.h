//
//  PlayerController.h
//  Gunnit
//
//  Created by Carl D on 10/6/13.
//  Copyright (c) 2013 Student. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerController : NSObject

// initialize object
-(id) initWithView:(UIView *)player Boundary:(CGRect)rect;

// reset position to middle of boundary
-(void) reset;

// move player
-(void)move:(float)dx;

// center point of player
-(CGPoint) center;

// check if the player intersects with the rectangle
-(BOOL) intersects:(CGRect)rect;

@end
