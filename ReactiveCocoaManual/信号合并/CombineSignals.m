//
//  CombineSignals.m
//  ReactiveCocoaManual
//
//  Created by ray on 2017/8/11.
//  Copyright © 2017年 ray. All rights reserved.
//

#import "CombineSignals.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CombineSignals ()
@property (nonatomic, strong) RACSignal *combineLatest;
@property (nonatomic, strong) RACSignal *combineLatestReduce;
@property (nonatomic, strong) RACSignal *zipSignal;
@property (nonatomic, strong) RACSignal *mergeSignal;
@property (nonatomic, strong) RACSignal *thenSignal;
@property (nonatomic, strong) RACSignal *concatSignal;
@property (nonatomic, strong) NSMutableArray *concatArray;
@property (nonatomic, strong) NSMutableArray *thenArray;
@property (nonatomic, strong) NSMutableArray *mergeArray;
@property (nonatomic, strong) NSMutableArray *zipArray;
@property (nonatomic, strong) NSMutableArray *combineLatestArray;
@property (nonatomic, strong) NSMutableArray *combineLatestReduceArray;
@end

@implementation CombineSignals

- (instancetype)init
{
    self = [super init];
    if (self) {
        _passwordSignal = [RACSubject subject];
        _userNameSignal = [RACSubject subject];
        
        _combineLatestArray = @[].mutableCopy;
        _combineLatest = [RACSignal combineLatest:@[_passwordSignal,_userNameSignal]];
        
        @weakify(self);
        [_combineLatest subscribeNext:^(RACTuple *x) {
            @strongify(self);
            [self.combineLatestArray addObject:x.allObjects];
        }];
        
        _combineLatestReduceArray = @[].mutableCopy;
        _combineLatestReduce =
        [RACSignal combineLatest:@[_passwordSignal,_userNameSignal] reduce:^id(NSString *password,NSString *userName){
            return [NSString stringWithFormat:@"%@%@",password,userName];
        }];
        [_combineLatestReduce subscribeNext:^(id x) {
            @strongify(self);
            [self.combineLatestReduceArray addObject:x];
        }];
        
        _zipArray = @[].mutableCopy;
        _zipSignal = [_passwordSignal zipWith:_userNameSignal];
        [_zipSignal subscribeNext:^(RACTuple *x) {
            @strongify(self);
            [self.zipArray addObject:x.allObjects];
        }];
        
        _mergeArray = @[].mutableCopy;
        _mergeSignal = [_passwordSignal merge:_userNameSignal];
        [_mergeSignal subscribeNext:^(id x) {
            @strongify(self);
            [self.mergeArray addObject:x];
        }];
        
        _thenArray = @[].mutableCopy;
        _thenSignal = [_passwordSignal then:^RACSignal *{
            return _userNameSignal;
        }];
        [_thenSignal subscribeNext:^(id x) {
            @strongify(self);
            [self.thenArray addObject:x];
        }];
        
        _concatArray = @[].mutableCopy;
        _concatSignal = [_passwordSignal concat:_userNameSignal];
        [_concatSignal subscribeNext:^(id x) {
            @strongify(self);
            [self.concatArray addObject:x];
        }];
    }
    return self;
}

- (NSArray *)concatResult {
    return self.concatArray.copy;
}

- (NSArray *)thenResult {
    return self.thenArray.copy;
}

- (NSArray *)mergeResult {
    return self.mergeArray.copy;
}

- (NSArray<NSArray *> *)zipResult {
    return self.zipArray.copy;
}

- (NSArray *)combineLatestReduceResult {
    return self.combineLatestReduceArray.copy;
}

- (NSArray<NSArray *> *)combineLatestResult {
    return self.combineLatestArray.copy;
}

@end
