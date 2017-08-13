//
//  FilterTest.m
//  ReactiveCocoaManual
//
//  Created by ray on 2017/8/13.
//  Copyright © 2017年 ray. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RACTest.h"

@interface FilterTest : RACTest

@end

@implementation FilterTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// 跳跃 ： 如下，skip传入2 跳过前面两个值
// 实际用处： 在实际开发中比如 后台返回的数据前面几个没用，我们想跳跃过去，便可以用skip
- (void)testSkip {
    RACSubject *subject = [RACSubject subject];
    NSMutableArray *resultArray = @[].mutableCopy;
    [[subject skip:2] subscribeNext:^(id x) {
        [resultArray addObject:x];
    }];
    NSArray *expectArray = @[];
    [subject sendNext:@1];
    XCTAssert([resultArray isEqualToArray:expectArray]);
    
    [subject sendNext:@2];
    XCTAssert([resultArray isEqualToArray:expectArray]);

    [subject sendNext:@3];
    expectArray = @[@3];
    XCTAssert([resultArray isEqualToArray:expectArray]);
}

//distinctUntilChanged:-- 如果当前的值跟上一次的值一样，就不会被订阅到
- (void)testDistinctUntilChanged {
    RACSubject *subject = [RACSubject subject];
    NSMutableArray *distinctArray = @[].mutableCopy;
    [[subject distinctUntilChanged] subscribeNext:^(id x) {
        [distinctArray addObject:x];
    }];
    NSArray *expectArray = @[@1];
    // 发送信号
    [subject sendNext:@1];
    XCTAssert([distinctArray isEqualToArray:expectArray]);
    
    [subject sendNext:@2];
    expectArray = @[@1,@2];
    XCTAssert([distinctArray isEqualToArray:expectArray]);
    
    [subject sendNext:@2]; // 不会被订阅
    XCTAssert([distinctArray isEqualToArray:expectArray]);

}

// take:可以屏蔽一些值,取前面几个值---这里take为2 则只拿到前两个值
- (void)testTake {
    RACSubject *subject = [RACSubject subject];
    NSMutableArray *takeArray = @[].mutableCopy;
    [[subject take:2] subscribeNext:^(id x) {
        [takeArray addObject:x];
    }];
    NSArray *expectArray = @[@1];
    // 发送信号
    [subject sendNext:@1];
    XCTAssert([takeArray isEqualToArray:expectArray]);
    
    [subject sendNext:@2];
    expectArray = @[@1,@2];
    XCTAssert([takeArray isEqualToArray:expectArray]);
    
    [subject sendNext:@3];
    XCTAssert([takeArray isEqualToArray:expectArray]);
}

//takeLast:和take的用法一样，不过他取的是最后的几个值，如下，则取的是最后两个值
//注意点:takeLast 一定要调用sendCompleted，告诉他发送完成了，这样才能取到最后的几个值
- (void)testTakeLast {
    RACSubject *subject = [RACSubject subject];
    NSMutableArray *takeArray = @[].mutableCopy;
    [[subject takeLast:2] subscribeNext:^(id x) {
        [takeArray addObject:x];
    }];
    // 发送信号
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
    NSArray *expectArray = @[];
    XCTAssert([takeArray isEqualToArray:expectArray]);
    
    [subject sendCompleted];
    expectArray = @[@2,@3];
    XCTAssert([takeArray isEqualToArray:expectArray]);
}

// takeUntil:---给takeUntil传的是哪个信号，那么当这个信号发送信号或sendCompleted，就不能再接受源信号的内容了。
- (void)testTakeUntil {
    RACSubject *subject = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    NSMutableArray *takeuntilArray = @[].mutableCopy;
    [[subject takeUntil:subject2] subscribeNext:^(id x) {
        [takeuntilArray addObject:x];
    }];
    // 发送信号
    [subject sendNext:@1];
    NSArray *expectArray = @[@1];
    XCTAssert([takeuntilArray isEqualToArray:expectArray]);
    
    [subject sendNext:@3];
    expectArray = @[@1,@3];
    XCTAssert([takeuntilArray isEqualToArray:expectArray]);

    [subject2 sendCompleted];
    [subject sendNext:@4];
    XCTAssert([takeuntilArray isEqualToArray:expectArray]);
}

- (void)testIgnore {
    //ignore:忽略一些值
    //ignoreValues:表示忽略所有的值
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    __block NSMutableArray *ignoreArray = @[].mutableCopy;
    // 2.忽略一些值
    RACSignal *ignoreSignal = [subject ignore:@2]; // ignoreValues:表示忽略所有的值
    // 3.订阅信号
    [ignoreSignal subscribeNext:^(id x) {
        [ignoreArray addObject:x];
    }];
    // 4.发送数据
    [subject sendNext:@2];
    XCTAssert([ignoreArray isEqualToArray:@[]]);
    
    [subject sendNext:@1];
    XCTAssert([ignoreArray isEqualToArray:@[@1]]);
}

- (void)testFilter {
    // 一般和文本框一起用，添加过滤条件
    // 只有当文本框的内容长度大于5，才获取文本框里的内容
    RACSubject *textSignal = [RACSubject subject];
    __block NSString *filterResult = @"";
    [[textSignal filter:^BOOL(NSString *value) {
        // value 源信号的内容
        return [value length] > 5;
        // 返回值 就是过滤条件。只有满足这个条件才能获取到内容
    }] subscribeNext:^(id x) {
        filterResult = x;
    }];  
    
    [textSignal sendNext:@"1111"];
    XCTAssert([filterResult isEqualToString:@""]);
    
    [textSignal sendNext:@"123456"];
    XCTAssert([filterResult isEqualToString:@"123456"]);
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

@end
