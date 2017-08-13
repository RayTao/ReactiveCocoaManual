//
//  CommandTest.m
//  ReactiveCocoaManual
//
//  Created by ray on 2017/8/12.
//  Copyright © 2017年 ray. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RACTest.h"
#import "CommandUsage.h"

@interface CommandTest : RACTest
@property (nonatomic, strong) CommandUsage *usage;

@end

@implementation CommandTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExcutSignal {
    XCTestExpectation *ex1 = [self expectationWithDescription:@"111"];

    __block NSMutableArray *latest = @[].mutableCopy;
    __block NSMutableArray *values = @[].mutableCopy;
    
    RACCommand *command = self.usage.command;
    [command.executionSignals subscribeNext:^(id x) {
        [values addObject:x];
    }];
    // switchToLatest获取最新发送的信号，只能用于信号中信号。
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        [latest addObject:x];
    }];
    
    // 2.执行命令
    [command execute:@1];
    [command execute:@2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // command在第一个信号结束前不会接受别的信号
        XCTAssert([latest.copy isEqualToArray:@[@1]]);
        XCTAssert(values.count == 1);
        [command execute:@3];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *array1 = @[@1,@3];
        XCTAssert([latest.copy isEqualToArray:array1]);
        // executionSignals获取每次action的信号
        XCTAssert([values.firstObject isKindOfClass:[RACSignal class]] && values.count == 2);
        [ex1 fulfill];
    });
    
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testExcuting {
    XCTestExpectation *ex1 = [self expectationWithDescription:@"111"];

    __block BOOL excuting = false;
    [self.usage.command.executing subscribeNext:^(NSNumber *x) {
        excuting = x.boolValue;
    }];
    [[[[self.usage.command execute:nil]
      doNext:^(id x) {
        XCTAssert(excuting == true);
    }] doCompleted:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            XCTAssert(excuting == false);
            [ex1 fulfill];
        });
        XCTAssert(excuting == true);
    }] subscribeCompleted:^{
        
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testCommandEnbaleAndInput {
    XCTestExpectation *ex1 = [self expectationWithDescription:@"111"];
//    ex1.expectedFulfillmentCount = 0.2f;

    XCTestExpectation *ex2 = [self expectationWithDescription:@"111"];
    ex2.expectedFulfillmentCount = 1.f;
    
    self.usage.enableCommand = false;
    [[self.usage.command execute:@"111"] subscribeNext:^(id x) {
    } completed:^{
        XCTAssertFalse(true,@"不会执行这段代码");
    }];
    
    self.usage.enableCommand = true;
    [[self.usage.command execute:@"ww"] subscribeNext:^(id x) {
        XCTAssert([self.usage.commandInput isEqual:@"ww"]);
        
        [ex1 fulfill];
        [ex2 fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (CommandUsage *)usage {
    if (!_usage) {
        _usage = [CommandUsage new];
    }
    return _usage;
}

@end
