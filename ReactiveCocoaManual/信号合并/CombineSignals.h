//
//  CombineSignals.h
//  ReactiveCocoaManual
//
//  Created by ray on 2017/8/11.
//  Copyright © 2017年 ray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSubject;

@interface CombineSignals : NSObject
@property (nonatomic, strong) RACSubject *passwordSignal;
@property (nonatomic, strong) RACSubject *userNameSignal;

- (NSArray *)concatResult;
- (NSArray *)thenResult;
- (NSArray *)mergeResult;
- (NSArray<NSArray *> *)zipResult;
- (NSArray *)combineLatestResult;
- (NSArray *)combineLatestReduceResult;

@end
