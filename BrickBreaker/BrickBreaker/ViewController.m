//
//  ViewController.m
//  BrickBreaker
//
//  Created by Student on 10/2/13.
//  Copyright (c) 2013 Student. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>

#import "PlayerController.h"
#import "EnemyController.h"

#import "SoundBuddy.h"

@interface ViewController ()

@end

// max amount of stars to create
const int MAX_STARS = 20;

// max enemies in the array
const int MAX_ENEMIES = 8;

// max time for cooldown reset (half a second)
const int COOLDOWN_TIMER_RESET = 30;

@implementation ViewController
{
    // variable to hold touch
    UITouch *_touch1;
    
    // holds the player controller
    PlayerController *_player;
    
    // box that the player is bound to
    CGRect _playerBox;
    
    // array to hold the enemies on the screen
    NSMutableArray *_enemies;
    
    // array to hold the stars on the screen
    NSMutableArray *_stars;
    
    // holds the width of the screen
    float _screenWidth;
    
    // holds the height of the screen
    float _screenHeight;
    
    // holds the delta x for the accelerometer
    float _dx;
    
    // checks to see if the gun is on cooldown
    BOOL _isOnCooldown;
    
    // timer for the cooldown
    int _cooldownTime;
    
    // timer for game
    int _gameTime;
    
    // amount of enemy kills
    int _kills;
    
    // holds the timer for the game
    CADisplayLink *_timer;
    
    // displays the messages for the game
    UIAlertView *_alert;
    
    // used to create the accelerometer
    CMMotionManager *_motionManager;
    NSOperationQueue *_queue;
    
    // SoundBuddy for game sounds
    SoundBuddy *_sound;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // set screen width and height to the width and height of the screen
    _screenWidth = self.view.bounds.size.width;
    _screenHeight = self.view.bounds.size.height;
    
    // create the motion manager for using the accelerometer
    _motionManager = [[CMMotionManager alloc] init];
    if (_motionManager.isDeviceMotionAvailable) {
        _motionManager.deviceMotionUpdateInterval = 1.0/60.0;
        
        //NSLog(@"Accelerometer avaliable");
        _queue = [NSOperationQueue currentQueue];
        [_motionManager startAccelerometerUpdatesToQueue:_queue
                                             withHandler:
         ^(CMAccelerometerData *accelerometerData, NSError *error) {
             CMAcceleration accel = accelerometerData.acceleration;
             
             // update the delta x
             _dx = accel.x;
         }];
        
    }
    
    // create the box that the player stays within
    _playerBox = CGRectMake(0, 400, 320, 80);
    
    // initialize the player
    _player = [[PlayerController alloc] initWithView:_viewPlayer
                                            Boundary:_playerBox];\
    
    // create the array for enemies
    _enemies = [NSMutableArray array];
    
    // initialize the enemies and add them to the array
    for(int i = 0; i < MAX_ENEMIES; i++)
    {
        UIImageView *enemyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enemyTest.png"]];
        EnemyController *enemy = [[EnemyController alloc] initWithView:enemyView maxHeight:_screenHeight maxWidth:_screenWidth];
        [self.view insertSubview:enemy.view atIndex:2];
        
        enemy.view.contentMode = UIViewContentModeScaleAspectFit;
        CGRect frame = enemy.frame;
        
        // resize the frames or else there are massive enemies
        frame.size.width = 50;
        frame.size.height = 50;
        enemy.view.frame = frame;
        
        _enemies[i] = enemy;
    }
    
    // create all the stars and store them in the array
    _stars = [NSMutableArray array];
    for (int i = 0; i < MAX_STARS; i++) {
        UIImageView *star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star.png"]];
        // place them above the background
        [self.view insertSubview:star atIndex:1];
        
        // makes it so that the images will be scalable
        star.contentMode = UIViewContentModeScaleAspectFit;
        CGRect frame = star.frame;
        frame.size.width = 20;
        star.frame = frame;
        
        // create a random position for them on screen
        float posX = arc4random_uniform(_screenWidth);
        float posY = arc4random_uniform(_screenHeight);
        
        _stars[i] = star;
        
        star.center = CGPointMake(posX, posY);
    }
    
    // initialize the sound buddy
    _sound = [[SoundBuddy alloc] init];
    
    [self newGame];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // iterate through our touch elements
    for (UITouch *touch in touches)
    {
        // get the point of touch within the view
        CGPoint touchPoint = [touch locationInView: self.view];
        
        // check to see if there has already been a touch on the screen
        // also checks if the weapon is on cooldown
        if (_touch1 == nil && !_isOnCooldown){
            _touch1 = touch;
            
            // play sound
            [_sound playSound:kSoundShoot];
            
            // weapon is on cooldown
            _isOnCooldown = YES;
            
            // the target is moved to the touch point
            self.viewTarget1.center = touchPoint;
            
            // if the target ever kills an enemy
            // then they take damage
            for (EnemyController *enemy in _enemies) {
                if([enemy intersects:self.viewTarget1.frame])
                {
                    [enemy loseHealth];
                }
            }
            
            // end the touch immediately
            [self touchesEnded:touches withEvent:event];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    // iterate through our touch elements
    for (UITouch *touch in touches)
    {
        if (touch == _touch1)
        {
            _touch1 = nil;
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesEnded:touches withEvent:event];
}

// called at the beginning of each round
- (void)reset{
    
    // play game track
    [_sound playSound:kSoundTrack];
    
    // reset the game time and the kills
    _kills = 0;
    _gameTime = 0;
    
    // weapon is not on cooldown
    _isOnCooldown = NO;
    
    // cooldown timer is set to 0
    _cooldownTime = 0;
    
    // reset the player
    [_player reset];
    
    // reset each enemy
    for (EnemyController *enemy in _enemies) {
        [enemy reset];
    }
    
    // unhides all the stars from the screen
    for (UIImageView *star in _stars) {
        star.hidden = NO;
    }
}

- (void)animate{
    
    // update the distance traveled
    _gameTime++;
    self.viewScore.text = [NSString stringWithFormat:@"Meters: %d", _gameTime];
    
    // update the player kills
    self.viewKills.text = [NSString stringWithFormat:@"Kills: %d", _kills];
    
    // if the weapon is on cooldown increment the timer
    if (_isOnCooldown) {
        _cooldownTime++;
        
        // if the timer is greater than the max reset time
        if(_cooldownTime >= COOLDOWN_TIMER_RESET)
        {
            // take the cooldown off
            // reset the timer
            _isOnCooldown = NO;
            _cooldownTime = 0;
        }
    }
    
    if(_cooldownTime == 0)
    {
        [self.viewBulletCD setProgress:1 animated:YES];
    }
    else
        [self.viewBulletCD setProgress:_cooldownTime/(float)COOLDOWN_TIMER_RESET*2 animated:YES];
    
    // move the player with the accelerometer
    [_player move:_dx];
    
    // animate the enemies and reset if they die
    for (EnemyController *enemy in _enemies) {
        [enemy animate];
        
        if ([enemy dead]) {
            _kills++;
            [enemy reset];
        }
    }
    
    // display the lose message if the game is over
    if([self checkGameOver])
        [self displayMessage:@"You have lost the game!"];
    
    // move all the stars through the screen
    for (UIImageView *star in _stars) {
        float starMoveY = star.center.y;
        starMoveY += 0.2;
        
        float starMoveX = star.center.x;
        starMoveX += _dx * -0.40;
        
        star.center = CGPointMake(starMoveX, starMoveY);
        
        if (star.center.y > _screenHeight + 30) {
            float startX = arc4random_uniform(_screenWidth);
            float startY = -10;
            star.center = CGPointMake(startX, startY);
        }
    }
}

- (void)start{
    
    if(_timer == nil){
        _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(animate)];
        [_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)stop{
    if(_timer != nil){
        // remove from all run loops and nil out
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)displayMessage:(NSString*)msg{
    // do not display more than one message
    if (_alert) return;
    // stop animation timer
    [self stop];
    // create and show alert message
    _alert = [[UIAlertView alloc] initWithTitle: @"Game"
                                        message: msg
                                       delegate: self
                              cancelButtonTitle: @"OK"
                              otherButtonTitles: nil];
    [_alert show];
}

- (void)newGame{
    [self reset];
    
    // present message to start game
    [self displayMessage: @"Press to Start"];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    // message dismissed so reset our game and start animation
    _alert = nil;
    
    // check if we should start a new game
    if ([self checkGameOver]){
        AppDelegate *app = (AppDelegate*) [UIApplication sharedApplication].delegate;
        
        // stop playing music
        [_sound stopSound:kSoundTrack];
        
        // show title screen
        [app showTitle];
        return;
    }
    // reset round
    [self reset];
    
    // start animation
    [self start];
}

- (BOOL)checkGameOver
{
    // if the player kills an enemy the game is over
    for (EnemyController *enemy in _enemies) {
        //if ([_player intersects:enemy.frame]) {
          //  [_sound playSound:kSoundCrash];
            //return YES;
        //}
    }
    return NO;
}

- (void)pause{
    [self stop];
}

- (void)resume{
    // present a mesage to continue game
    [self displayMessage: @"Game Paused"];
}

// shake
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionBegan:(UIEventSubtype)motion
          withEvent:(UIEvent *)event
{
    if (event.type == UIEventSubtypeMotionShake)
    {
        // pause game then resume to display message
        [self pause];
        [self resume];
    }
}

- (void)motionEnded:(UIEventSubtype)motion
          withEvent:(UIEvent *)event
{
    if (event.type == UIEventSubtypeMotionShake)
    {
        //NSLog(@"Shake Ended");
    }
}
- (void)motionCancelled:(UIEventSubtype)motion
              withEvent:(UIEvent *)event
{
    if (event.type == UIEventSubtypeMotionShake)
    {
        //NSLog(@"Shake Cancelled");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate{
    return NO;
}

@end
