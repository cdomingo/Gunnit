//
//  TitleViewController.m
//  Gunnit
//
//  Created by Carl D on 10/19/13.
//  Copyright (c) 2013 Student. All rights reserved.
//

#import "TitleViewController.h"
#import "AppDelegate.h"

@interface TitleViewController ()

@end

@implementation TitleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPlay:(id)sender
{
    // call the delegate and run the playGame function
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app playGame];
}

@end
