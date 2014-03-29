//
//  SoundBuddy.m
//  Gunnit
//
//  Created by Carl D on 10/20/13.
//  Copyright (c) 2013 Student. All rights reserved.
//

#import "SoundBuddy.h"

static float const kSoundDefaultVolume = .5;

@implementation SoundBuddy
{
    NSMutableDictionary *_soundDictionary;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        _soundDictionary = [NSMutableDictionary dictionary];
        [self createChannel: kSoundCrash];
        [self createChannel: kSoundShoot];
        [self createChannel: kSoundTrack];
    }
    return self;
}

-(void)playSound:(NSString *)fileName
{
    AVAudioPlayer *player = _soundDictionary[fileName];
    player.currentTime = 0;
    [player play];
}

-(void)stopSound:(NSString *)fileName
{
    AVAudioPlayer *player = _soundDictionary[fileName];
    [player stop];
}

-(void)createChannel:(NSString *)fileName
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"wav"];
    
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    
    NSError *error;
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    
    player.volume = kSoundDefaultVolume;
    
    [player prepareToPlay];
    
    _soundDictionary[fileName] = player;
}

@end
