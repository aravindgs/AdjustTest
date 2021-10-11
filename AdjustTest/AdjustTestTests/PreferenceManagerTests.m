//
//  PreferenceManagerTests.m
//  AdjustTestTests
//
//  Created by Aravind GS on 11/10/21.
//

#import <XCTest/XCTest.h>
#import "PreferenceManager.h"

@interface PreferenceManagerTests : XCTestCase

@property PreferenceManager *preference;

@end

@implementation PreferenceManagerTests
@synthesize preference;

static NSString *unsentSecondsKey = @"unsentSeconds";
static NSString *sentSecondsKey = @"sentSeconds";
NSUserDefaults *defaults;

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    preference = [[PreferenceManager alloc] init];
    defaults = [NSUserDefaults standardUserDefaults];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSaveUnsent {
    NSArray<NSString *> *expectedArray = @[@"21", @"15", @"12"];
    [preference saveUnsentSecondsArray:expectedArray];
    NSArray<NSString *> *resultArray = (NSArray<NSString *> *) [defaults arrayForKey:unsentSecondsKey];
    XCTAssert([resultArray isEqualToArray:expectedArray]);
}

- (void)testSaveSent {
    NSArray<NSString *> *expectedArray = @[@"16", @"19", @"52"];
    [preference saveSentSecondsArray:expectedArray];
    NSArray<NSString *> *resultArray = (NSArray<NSString *> *) [defaults arrayForKey:sentSecondsKey];
    XCTAssert([resultArray isEqualToArray:expectedArray]);
}

- (void)testGetUnsentSecondsArray {
    NSArray<NSString *> *expectedArray = @[@"20", @"28", @"46"];
    [defaults setObject:expectedArray forKey:unsentSecondsKey];
    [defaults synchronize];
    NSArray<NSString *> *resultArray = [preference getUnsentSecondsArray];
    XCTAssert([resultArray isEqualToArray:expectedArray]);
}

- (void)testSentSecondsArray {
    NSArray<NSString *> *expectedArray = @[@"20", @"28", @"46"];
    [defaults setObject:expectedArray forKey:sentSecondsKey];
    [defaults synchronize];
    NSArray<NSString *> *resultArray = [preference getSentSecondsArray];
    XCTAssert([resultArray isEqualToArray:expectedArray]);
}

- (void)testFlush {
    NSArray <NSString *> *expectedArray = @[];
    [self testSaveUnsent];
    [preference flush];
    NSArray<NSString *> *resultArray = (NSArray <NSString *>*)[defaults arrayForKey:unsentSecondsKey];
    XCTAssert([resultArray isEqualToArray:expectedArray]);
}

@end
