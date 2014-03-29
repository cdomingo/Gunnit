//
//  ViewController.h
//  BrickBreaker
//
//  Created by Student on 10/2/13.
//  Copyright (c) 2013 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

// UI Image Views for all the objects in the iPhone nib
@property (weak, nonatomic) IBOutlet UIImageView *viewPlayer;
@property (weak, nonatomic) IBOutlet UIImageView *viewTarget1;
@property (weak, nonatomic) IBOutlet UILabel *viewScore;
@property (weak, nonatomic) IBOutlet UILabel *viewKills;
@property (weak, nonatomic) IBOutlet UIProgressView *viewBulletCD;

// pause and resume methods
-(void) resume;
-(void) pause;

@end
