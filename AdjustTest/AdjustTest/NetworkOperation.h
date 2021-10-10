//
//  NetworkOperation.h
//  AdjustTest
//
//  Created by Aravind GS on 10/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkOperation : NSOperation

@property (nonatomic) NSString *second;
@property (nonatomic, copy) void (^finishBlock)(NSDictionary * _Nullable res, BOOL isSuccess, NSString * _Nullable number);

- (instancetype) initWithSecond:(NSString *) current completion:(void (^)(NSDictionary * _Nullable res, BOOL isSuccess, NSString * _Nullable number)) completion;

@end

NS_ASSUME_NONNULL_END
