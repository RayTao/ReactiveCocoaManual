//
//  Command.h
//  ReactiveCocoaManual
//
//  Created by ray on 2016/11/18.
//  Copyright © 2016年 ray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface Command : NSObject


@property (nonatomic, strong) RACCommand *testCommand;

/**
 使用materialize，executionSignals可获取到next,error,complete,
 但是所有事件都发送到nextsubscribenext
 */
@property (nonatomic, strong) RACCommand *materializeCommand;

@end
