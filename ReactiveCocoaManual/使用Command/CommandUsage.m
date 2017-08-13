//
//  CommandUsage.m
//  ReactiveCocoaManual
//
//  Created by ray on 2017/8/12.
//  Copyright © 2017年 ray. All rights reserved.
//

#import "CommandUsage.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CommandUsage ()
@property (nonatomic, strong) RACSignal *enableSignal;
@property (nonatomic, strong) id commandResult;
@end

@implementation CommandUsage

- (instancetype)init
{
    self = [super init];
    if (self) {
        _enableCommand = true;
    }
    return self;
}

- (id)commandInput {
    return self.commandResult;
}

- (RACSignal *)testSignal:(id)input {
    @weakify(self);
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        self.commandResult = input;
        [subscriber sendNext:input];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)enableSignal {
    if (!_enableSignal) {
        _enableSignal = RACObserve(self, enableCommand);
    }
    return _enableSignal;
}

- (RACCommand *)command {
    if (!_command) {
        @weakify(self);
        _command = [[RACCommand alloc] initWithEnabled:self.enableSignal signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self testSignal:input];
        }];
    }
    return _command;
}

@end
