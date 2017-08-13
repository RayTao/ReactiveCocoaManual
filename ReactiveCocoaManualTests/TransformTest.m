//
//  TransformTest.m
//  ReactiveCocoaManual
//
//  Created by ray on 2017/8/13.
//  Copyright © 2017年 ray. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RACTest.h"
#import "RACTransform.h"

@interface TransformTest : RACTest
@property (nonatomic, strong) RACTransform *usage;
@end

@implementation TransformTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/// flattenMap: 将原来的信号 创建一个新的信号
- (void)testFlattenMap {
    RACSubject *signalofSignals = self.usage.headSubject;
    RACSubject *signal = self.usage.footerSubject;
    
    __block id input;
    __block NSString *result;
    [[signalofSignals flattenMap:^RACStream *(id value) {
        input = value;
        return signal;
    }] subscribeNext:^(id x) {
        result = x;
    }];
    
    // 发送信号
    [signalofSignals sendNext:@"0"];
    [signal sendNext:[NSString stringWithFormat:@"%@%@",@"123",input]];
    XCTAssert([result isEqualToString:@"1230"]);
}

/// map: 原来的signal没有改变 只改变了value
- (void)testMap {
    RACSignal *mapSignal = [self.usage.headSubject map:^id(id value) {
        return [NSString stringWithFormat:@"ws:%@",value];
    }];
    __block NSString *mapResult = @"";
    [mapSignal subscribeNext:^(id x) {
        mapResult = x;
    }];
    
    [self.usage.headSubject sendNext:@"110"];
    XCTAssert([mapResult isEqualToString:@"ws:110"]);
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

- (RACTransform *)usage {
    if (!_usage) {
        _usage = [RACTransform new];
    }
    return _usage;
}

@end
