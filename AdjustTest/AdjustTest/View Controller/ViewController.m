//
//  ViewController.m
//  AdjustTest
//
//  Created by Aravind GS on 10/10/21.
//

#import "ViewController.h"
#import "NetworkOperation.h"

@implementation ViewController

@synthesize sentSeconds;
@synthesize unsentSeconds;
@synthesize networkQ;
@synthesize preference;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    preference = [[PreferenceManager alloc] init];
    [self setupOperationQueue];
    
    sentSeconds = [[NSMutableArray alloc] initWithArray:[preference getSentSecondsArray]];
    unsentSeconds = [NSMutableArray array];
    [self flushUnsent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelAndSave) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelAndSave) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flushUnsent) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void) setupOperationQueue {
    if (networkQ != nil) { return; }
    networkQ = [[NSOperationQueue alloc] init];
    [networkQ setName:@"Adjust Network Queue"];
    [networkQ setMaxConcurrentOperationCount:1];
}

- (IBAction)captureSecond {
    if ([sentSeconds count] >= 60) { return; }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ss"];
    NSString *seconds =  [dateFormatter stringFromDate:[NSDate date]];
    if ([sentSeconds containsObject:seconds] || [unsentSeconds containsObject:seconds]) {
        NSLog(@"Request not sent. Repeated second = %@", seconds);
        return;
    }
    [unsentSeconds addObject:seconds];
    [self sendSecondToServer:seconds];
}

- (void) sendSecondToServer:(NSString *)second {
    NetworkOperation *op = [[NetworkOperation alloc] initWithSecond:second completion:^(NSDictionary * _Nullable res, BOOL isSuccess, NSString * _Nullable number) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *resId = [res valueForKey:@"id"];
            NSString *seconds = [res valueForKey:@"seconds"];
            [self->unsentSeconds removeObject:seconds];
            if (isSuccess && resId != nil && seconds != nil) {
                NSLog(@"id = %@ \t seconds = %@", resId, seconds);
                [self->sentSeconds addObject:seconds];
            }
        });
    }];
    [networkQ addOperation:op];
}

- (void) cancelAndSave {
    [networkQ setSuspended:YES];
    NSArray <NetworkOperation *> *operations = (NSArray <NetworkOperation *> *)[networkQ operations];
    NSMutableArray <NSString *> *unsent = [NSMutableArray array];
    for (NetworkOperation *op in operations) { [unsent addObject:op.second]; }
    [networkQ cancelAllOperations];
    networkQ = nil;
    [preference saveUnsentSecondsArray:unsent];
    [preference saveSentSecondsArray:sentSeconds];
}

- (void) flushUnsent {
    [self setupOperationQueue];
    NSArray <NSString *> *unsent = [NSMutableArray arrayWithArray:[preference getUnsentSecondsArray]];
    [preference flush];
    for (NSString *second in unsent) {
        [unsentSeconds addObject:second];
        [self sendSecondToServer:second];
    }
}

@end
