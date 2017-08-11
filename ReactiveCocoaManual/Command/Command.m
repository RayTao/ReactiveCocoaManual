//
//  Command.m
//  ReactiveCocoaManual
//
//  Created by ray on 2016/11/18.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "Command.h"

@implementation Command



- (RACSignal *)testSignal:(id)input {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (input == nil) {
                [subscriber sendError:[[NSError alloc] initWithDomain:@"6666" code:0 userInfo:nil]];
                NSLog(@"error ...");
            } else {
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                NSLog(@"next ... and completed");

            }
        });
        
        return nil;
    }];
}


- (RACCommand *)materializeCommand {
    if (nil == _materializeCommand) {
        @weakify(self);
        _materializeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            //materialize是为了处理拿不到error的问题
            return [[self testSignal:input] materialize];
        }];
    }
    return _materializeCommand;
}

- (RACCommand *)testCommand {
    if (nil == _testCommand) {
        @weakify(self);
        _testCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self testSignal:input];
        }];
    }
    return _testCommand;
}

@end
