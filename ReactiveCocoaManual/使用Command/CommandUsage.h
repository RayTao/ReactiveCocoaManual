//
//  CommandUsage.h
//  ReactiveCocoaManual
//
//  Created by ray on 2017/8/12.
//  Copyright © 2017年 ray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACCommand;
@class RACSignal;

@interface CommandUsage : NSObject

@property (nonatomic, assign) BOOL enableCommand;
@property (nonatomic, strong) RACCommand *command;

- (id)commandInput;
@end
