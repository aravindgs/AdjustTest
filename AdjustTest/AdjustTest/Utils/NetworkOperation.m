//
//  NetworkOperation.m
//  AdjustTest
//
//  Created by Aravind GS on 10/10/21.
//

#import "NetworkOperation.h"

@interface NetworkOperation()

@end

@implementation NetworkOperation

@synthesize second;
@synthesize finishBlock;

@synthesize ready = _ready;
@synthesize executing = _executing;
@synthesize finished = _finished;

#pragma mark - Init
- (instancetype)initWithSecond:(NSString *)current completion:(void (^)(NSDictionary * _Nullable, BOOL, NSString * _Nullable))handler {
    self = [super init];
    self.ready = YES;
    second = current;
    finishBlock = handler;
    return self;
}

#pragma mark - State
- (void)setReady:(BOOL)ready
{
    if (_ready != ready)
    {
        [self willChangeValueForKey:NSStringFromSelector(@selector(isReady))];
        _ready = ready;
        [self didChangeValueForKey:NSStringFromSelector(@selector(isReady))];
    }
}

- (BOOL)isReady
{
    return _ready;
}

- (void)setExecuting:(BOOL)executing
{
    if (_executing != executing)
    {
        [self willChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
        _executing = executing;
        [self didChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
    }
}

- (BOOL)isExecuting
{
    return _executing;
}

- (void)setFinished:(BOOL)finished
{
    if (_finished != finished)
    {
        [self willChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
        _finished = finished;
        [self didChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
    }
}

- (BOOL)isFinished
{
    return _finished;
}

- (BOOL)isAsynchronous
{
    return YES;
}

- (void)start {
    NSURL *url = [NSURL URLWithString:@"https://jsonplaceholder.typicode.com/posts"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSDictionary *bodyDict = @{@"seconds" : second };
    NSError *error;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&error];
    [request setHTTPBody:bodyData];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if ([httpResponse statusCode] == 201) {
            NSError *error;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error == nil) {
                self.finishBlock(responseDict, YES, nil);
            } else {
                self.finishBlock(nil, NO, self->second);
            }
        } else {
            self.finishBlock(nil, NO, self->second);
        }
        [self finish];
    }];
    [dataTask resume];
}

- (void)finish
{
    if (self.executing) { self.executing = NO; }
    self.finished = YES;
}

@end
