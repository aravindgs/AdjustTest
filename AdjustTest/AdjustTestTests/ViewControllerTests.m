//
//  ViewControllerTests.m
//  AdjustTestTests
//
//  Created by Aravind GS on 11/10/21.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface ViewControllerTests : XCTestCase

@property ViewController *vc;

@end

@implementation ViewControllerTests

@synthesize vc;

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    vc = [[ViewController alloc] init];
    vc.sentSeconds = [NSMutableArray array];
    vc.unsentSeconds = [NSMutableArray array];
    vc.preference = [[PreferenceManager alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSetupOperationQueue {
    [vc setupOperationQueue];
    XCTAssert(vc.networkQ != nil);
}

- (void)testCancelAndSave {
    NSArray <NSString *> *expectedUnsentArray = @[@"12",@"15", @"18", @"10"];
    NSArray <NSString *> *expectedSentArray = @[@"21", @"26", @"36"];
    [vc.sentSeconds addObjectsFromArray:expectedSentArray];
    for (NSString *second in expectedUnsentArray) {
        [vc sendSecondToServer:second];
    }
    [vc cancelAndSave];
    NSArray <NSString *> *resultSavedSentArray = (NSArray <NSString *> *)[[NSUserDefaults standardUserDefaults] arrayForKey:@"sentSeconds"];
    XCTAssert(vc.networkQ == nil);
    XCTAssert([resultSavedSentArray isEqualToArray:expectedSentArray]);
}

- (void)testFlushUnsent {
    NSArray<NSString *> *unsentArray = @[@"23", @"27", @"38"];
    [[NSUserDefaults standardUserDefaults] setObject:unsentArray forKey:@"unsentSeconds"];
    [vc flushUnsent];
    NSArray<NSString *> *finalUnsent = [[NSUserDefaults standardUserDefaults] arrayForKey:@"unsentSeconds"];
    XCTAssert([finalUnsent isEqualToArray:@[]]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
