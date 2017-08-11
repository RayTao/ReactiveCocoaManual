//
//  CombineSignalsTest.m
//  ReactiveCocoaManual
//
//  Created by ray on 2017/8/11.
//  Copyright © 2017年 ray. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RACTest.h"
#import "CombineSignals.h"


@interface CombineSignalsTest : RACTest

@end

@interface CombineSignalsTest ()
@property (nonatomic, strong) CombineSignals *combineSignal;

@end

@implementation CombineSignalsTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/// contact --- 使用需求：使用需求：有两部分数据：想让上部分先执行，完了之后再让下部分执行（都可获取值,不会合并成一个元祖）
/// 想让下一个信号触发，第一个信号必须sendcomplete
- (void)testContact {
    [self.combineSignal.passwordSignal sendNext:@"222"];
    NSArray *array = @[@"222"];
    XCTAssert([self.combineSignal.concatResult isEqualToArray:array]);
    
    [self.combineSignal.userNameSignal sendNext:@"111"];
    XCTAssert([self.combineSignal.concatResult isEqualToArray:array]);
    
    [self.combineSignal.passwordSignal sendCompleted];
    XCTAssert([self.combineSignal.concatResult isEqualToArray:array]);
    
    [self.combineSignal.userNameSignal sendNext:@"33"];
    array = @[@"222",@"33"];
    XCTAssert([self.combineSignal.concatResult isEqualToArray:array]);
}

/// then --- 使用需求：有两部分数据：想让上部分先进行但是处理掉数据，然后进行下部分的，拿到下部分数据
/// 想让信号触发，第一个信号必须sendcomplete, 最后拿到的只有下部份数据
- (void)testThen {
    [self.combineSignal.passwordSignal sendNext:@"222"];
    NSArray *array = @[];
    XCTAssert([self.combineSignal.thenResult isEqualToArray:array]);
    
    [self.combineSignal.userNameSignal sendNext:@"111"];
    XCTAssert([self.combineSignal.thenResult isEqualToArray:array]);
    
    [self.combineSignal.passwordSignal sendCompleted];
    XCTAssert([self.combineSignal.thenResult isEqualToArray:array]);
    
    [self.combineSignal.userNameSignal sendNext:@"33"];
    array = @[@"33"];
    XCTAssert([self.combineSignal.thenResult isEqualToArray:array]);
}

/// merge:多个信号合并成一个信号，任何一个信号有新值就会调用,但是不会合并成一个元祖
- (void)testMerge {
    [self.combineSignal.passwordSignal sendNext:@"222"];
    NSArray *array = @[@"222"];
    XCTAssert([self.combineSignal.mergeResult isEqualToArray:array]);
    
    [self.combineSignal.userNameSignal sendNext:@"111"];
    array = @[@"222",@"111"];
    XCTAssert([self.combineSignal.mergeResult isEqualToArray:array]);
    
    [self.combineSignal.userNameSignal sendNext:@"44"];
    array = @[@"222",@"111",@"44"];
    XCTAssert([self.combineSignal.mergeResult isEqualToArray:array]);
    
    [self.combineSignal.passwordSignal sendNext:@"33"];
    array = @[@"222",@"111",@"44",@"33"];
    XCTAssert([self.combineSignal.mergeResult isEqualToArray:array]);
}

/// zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元祖，才会触发压缩流的next事件
- (void)testZip {
    [self.combineSignal.passwordSignal sendNext:@"222"];
    XCTAssert([self.combineSignal.zipResult isEqualToArray:@[]]);
    
    [self.combineSignal.userNameSignal sendNext:@"111"];
    NSArray *array = @[@[@"222",@"111"]];
    XCTAssert([self.combineSignal.zipResult isEqualToArray:array]);
    
    [self.combineSignal.userNameSignal sendNext:@"44"];
    XCTAssert([self.combineSignal.zipResult isEqualToArray:array]);
    
    [self.combineSignal.passwordSignal sendNext:@"33"];
    array = @[@[@"222",@"111"],@[@"33",@"44"]];
    XCTAssert([self.combineSignal.zipResult isEqualToArray:array]);
}

/// combineLatest：Combines the latest values from the given signals into RACTuples, once all the signals have sent at least one `next`.
/// Any additional `next`s will result in a new RACTuple with the latest values from all signals.
/// 当所有信号都sendnext至少一次之后才会组合最新的值出发sendnext
- (void)testCombinLatest {
    [self.combineSignal.passwordSignal sendNext:@"222"];
    XCTAssert([self.combineSignal.combineLatestResult isEqualToArray:@[]]);
    
    [self.combineSignal.userNameSignal sendNext:@"111"];
    NSArray *array = @[@"222",@"111"];
    XCTAssert([self.combineSignal.combineLatestResult isEqualToArray:@[array]]);
    
    [self.combineSignal.userNameSignal sendNext:@"44"];
    array = @[@[@"222",@"111"],@[@"222",@"44"]];
    XCTAssert([self.combineSignal.combineLatestResult isEqualToArray:array]);
}

/// combineLatest: reduce:Combines signals using +combineLatest:, then reduces the resulting tuples into a single value using -reduceEach:
/// 先调用combineLatest，再调用reduces组合成一个新值
- (void)testCombinLatestReduce {
    [self.combineSignal.passwordSignal sendNext:@"222"];
    XCTAssert([self.combineSignal.combineLatestReduceResult isEqualToArray:@[]]);
    
    [self.combineSignal.userNameSignal sendNext:@"111"];
    XCTAssert([self.combineSignal.combineLatestReduceResult isEqualToArray:@[@"222111"]]);
    
    [self.combineSignal.userNameSignal sendNext:@"44"];
    NSArray *array = @[@"222111",@"22244"];
    XCTAssert([self.combineSignal.combineLatestReduceResult isEqualToArray:array]);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (CombineSignals *)combineSignal {
    if (!_combineSignal) {
        _combineSignal = [CombineSignals new];
    }
    return _combineSignal;
}

@end
