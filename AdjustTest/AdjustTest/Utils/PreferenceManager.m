//
//  PreferenceManager.m
//  AdjustTest
//
//  Created by Aravind GS on 10/10/21.
//

#import "PreferenceManager.h"

@implementation PreferenceManager

static NSString *unsentSecondsKey = @"unsentSeconds";
static NSString *sentSecondsKey = @"sentSeconds";

@synthesize prefs;

- (instancetype)init
{
    self = [super init];
    if (self) {
        prefs = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)saveUnsentSecondsArray : (NSArray <NSString *> *) secondsArray {
    [prefs setObject:secondsArray forKey:unsentSecondsKey];
    [prefs synchronize];
}


- (NSArray <NSString *> *)getUnsentSecondsArray {
    NSArray <NSString *> *unsentSeconds = [prefs arrayForKey:unsentSecondsKey];
    return  (unsentSeconds == nil ? @[] : unsentSeconds);
}

- (void)saveSentSecondsArray : (NSArray <NSString *> *) secondsArray {
    [prefs setObject:secondsArray forKey:sentSecondsKey];
    [prefs synchronize];
}

- (NSArray <NSString *> *) getSentSecondsArray {
    NSArray <NSString *> *sentSeconds = [prefs arrayForKey:sentSecondsKey];
    return  (sentSeconds == nil ? @[] : sentSeconds);
}

- (void)flush {
    [prefs setObject:@[] forKey:unsentSecondsKey];
    [prefs synchronize];
    
}

@end
