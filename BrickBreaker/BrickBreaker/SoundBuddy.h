//
//  SoundBuddy.h
//  Gunnit
//
//  Created by Carl D on 10/20/13.
//  Copyright (c) 2013 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

static NSString* const kSoundCrash = @"crash";
static NSString* const kSoundShoot = @"laser";
static NSString* const kSoundTrack = @"SkyFortress";

@interface SoundBuddy : NSObject

-(void)playSound:(NSString *)fileName;
-(void)stopSound:(NSString *)fileName;

@end
