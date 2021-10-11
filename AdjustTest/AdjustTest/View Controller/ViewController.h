//
//  ViewController.h
//  AdjustTest
//
//  Created by Aravind GS on 10/10/21.
//

#import <UIKit/UIKit.h>
#import "PreferenceManager.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) NSMutableArray<NSString *> *sentSeconds;
@property (nonatomic, strong) NSMutableArray <NSString *> *unsentSeconds;
@property (nonatomic, strong) NSOperationQueue *networkQ;
@property (nonatomic, strong) PreferenceManager *preference;

- (void) sendSecondToServer:(NSString *)second;

- (void) setupOperationQueue;

- (void) cancelAndSave;

- (void) flushUnsent;

@end

