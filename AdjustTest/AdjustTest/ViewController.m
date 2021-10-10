//
//  ViewController.m
//  AdjustTest
//
//  Created by Aravind GS on 10/10/21.
//

#import "ViewController.h"
#import "NetworkOperation.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray<NSString *> *sentSeconds;
@property (nonatomic, strong) NSOperationQueue *networkQ;

@end

@implementation ViewController

@synthesize sentSeconds;
@synthesize networkQ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sentSeconds = [[NSMutableArray alloc] init];
    networkQ = [[NSOperationQueue alloc] init];
    [networkQ setName:@"Adjust Network Queue"];
    [networkQ setMaxConcurrentOperationCount:1];
}

- (IBAction)captureSecond {
    if ([sentSeconds count] >= 60) { return; }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ss"];
    NSString *seconds =  [dateFormatter stringFromDate:[NSDate date]];
    if ([sentSeconds containsObject:seconds]) { return; }
    [sentSeconds addObject:seconds];
    [self sendSecondToServer:seconds];
}

- (void) sendSecondToServer:(NSString *)second {
    NetworkOperation *op = [[NetworkOperation alloc] initWithSecond:second completion:^(NSDictionary * _Nullable res, BOOL isSuccess, NSString * _Nullable number) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *resId = [res valueForKey:@"id"];
            NSString *seconds = [res valueForKey:@"seconds"];
            if (isSuccess && resId != nil && seconds != nil) {
                NSLog(@"id = %@ \t seconds = %@", resId, seconds);
            } else {
                [self->sentSeconds removeObject:number];
            }
        });
    }];
    [networkQ addOperation:op];
}

@end
