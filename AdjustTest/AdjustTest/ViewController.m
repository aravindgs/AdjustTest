//
//  ViewController.m
//  AdjustTest
//
//  Created by Aravind GS on 10/10/21.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray<NSNumber *> *sentSeconds;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sentSeconds = [[NSMutableArray alloc] init];
}

- (IBAction)captureSecond {
    if ([self.sentSeconds count] >= 60) { return; }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ss"];
    NSInteger seconds = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
    if ([self.sentSeconds containsObject:[NSNumber numberWithInteger:seconds]]) { return; }
    [self.sentSeconds addObject:[NSNumber numberWithInteger:seconds]];
    [self sendSecondToServer:seconds];
}

- (void) sendSecondToServer:(NSInteger)second {
    
}

@end
