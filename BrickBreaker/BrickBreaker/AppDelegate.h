//
//  AppDelegate.h
//  BrickBreaker
//
//  Created by Student on 10/2/13.
//  Copyright (c) 2013 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class TitleViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TitleViewController *viewController;
@property (strong, nonatomic) ViewController *gameController;

-(void)showTitle;
-(void)playGame;

@end
