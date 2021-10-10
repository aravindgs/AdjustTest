//
//  PreferenceManager.h
//  AdjustTest
//
//  Created by Aravind GS on 10/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreferenceManager : NSObject

@property(nonatomic, strong) NSUserDefaults *prefs;

- (void)saveUnsentSecondsArray :(NSArray <NSString *> *) secondsArray;
- (NSArray <NSString *> *)getUnsentSecondsArray;

- (void)saveSentSecondsArray : (NSArray <NSString *> *) secondsArray;
- (NSArray <NSString *> *)getSentSecondsArray;

- (void)flush;

@end

NS_ASSUME_NONNULL_END
