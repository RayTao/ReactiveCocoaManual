//
//  HotColdObservable.m
//  ReactiveCocoaManual
//
//  Created by ray on 15/11/24.
//  Copyright © 2015年 ray. All rights reserved.
//

#import "HotColdObservable.h"

@implementation HotColdObservable

- (void)coldObservableTest {
    NSLog(@"%s start",__FUNCTION__);

    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendNext:@3];
        [subscriber sendCompleted];
        return nil;
    }];
    NSLog(@"Signal was created.");
    [[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
        [signal subscribeNext:^(id x) {
            NSLog(@"Subscriber 1 recveive: %@", x);
        }];
    }];
    [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
        [signal subscribeNext:^(id x) {
            NSLog(@"Subscriber 2 recveive: %@", x);
        }];
    }];

}

- (void)hotObservableTest {
    NSLog(@"%s start",__FUNCTION__);
    RACMulticastConnection *connection = [[RACSignal createSignal:^RACDisposable *(id subscriber) {
        [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
            [subscriber sendNext:@1];
        }];
        [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
            [subscriber sendNext:@2];
        }];
        [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
            [subscriber sendNext:@3];
        }];
        [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
            [subscriber sendCompleted];
        }];
        return nil;
    }] publish];
    [connection connect];
    RACSignal *signal = connection.signal;
    NSLog(@"Signal was created.");
    [[RACScheduler mainThreadScheduler] afterDelay:1.1 schedule:^{
        [signal subscribeNext:^(id x) {
            NSLog(@"Subscriber 1 recveive: %@", x);
        }];
    }];
    [[RACScheduler mainThreadScheduler] afterDelay:2.1 schedule:^{
        [signal subscribeNext:^(id x) {
            NSLog(@"Subscriber 2 recveive: %@", x);
        }];
    }];
}

- (void)whyHotObservable {

}

@end
