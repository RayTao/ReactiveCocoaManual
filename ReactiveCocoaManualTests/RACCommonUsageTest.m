//
//  RACCommonUsageTest.m
//  ReactiveCocoaManual
//
//  Created by ray on 2017/8/12.
//  Copyright © 2017年 ray. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RACTest.h"
#import "RACCommonUsage.h"

@interface RACCommonUsageTest : RACTest

@property (nonatomic, strong) RACCommonUsage *usage;

@end

@implementation RACCommonUsageTest

- (void)testMulticastConnection {
    
    __block NSMutableArray *signalArray = @[].mutableCopy;
    // 1.发送请求，用一个信号内包装，不管有多少个订阅者，只想发一次请求
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"发送请求啦");
        [signalArray addObject:@"ws"];
        // 发送信号
        [subscriber sendNext:@"ws"];
        return nil;
    }];
    
    [signal subscribeNext:^(id x) {
//        [signalArray addObject:x];
    }];
    [signal subscribeNext:^(id x) {
//        [signalArray addObject:x];
    }];
    [signal subscribeNext:^(id x) {
//        [signalArray addObject:x];
    }];
    NSArray *expectArray = @[@"ws",@"ws",@"ws"];
    // 直接订阅signal的subscribeNext副作用每次都会触发
    XCTAssert([signalArray.copy isEqualToArray:expectArray]);
    
    //2. 创建连接类
    RACMulticastConnection *connection = [signal publish];
    __block NSMutableArray *connectionArray = @[].mutableCopy;
    [connection.signal subscribeNext:^(id x) {
        [connectionArray addObject:x];
    }];
    [connection.signal subscribeNext:^(id x) {
        [connectionArray addObject:x];
    }];
    [connection.signal subscribeNext:^(id x) {
        [connectionArray addObject:x];
    }];
    expectArray = @[];
    XCTAssert([connectionArray.copy isEqualToArray:expectArray]);

    //3. 连接。只有连接了才会把信号源变为热信号
    [connection connect];
    // 使用RACMulticastConnection，无论有多少个订阅者，无论订阅多少次，我只发送一个
    expectArray = [expectArray arrayByAddingObject:@"ws"];
    XCTAssert([signalArray.copy isEqualToArray:expectArray]);
}


- (void)testTimer {
    XCTestExpectation *ex1 = [self expectationWithDescription:@"111"];
    ex1.expectedFulfillmentCount = 1.0f;
    NSDate *date1 = [NSDate date];
    // 延迟事件
    [[RACScheduler mainThreadScheduler] afterDelay:0.5 schedule:^{
        NSDate *date2 = [NSDate date];
        NSTimeInterval duration = [date2 timeIntervalSinceDate:date1];
        XCTAssert(duration > 0.4 && duration < 0.6);
        [ex1 fulfill];
    }];

    XCTestExpectation *ex2 = [self expectationWithDescription:@"222"];
    __block int time = 0;
    //2.每间隔多长时间做一件
    [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]]
      take:3]
     subscribeNext:^(id x) {
         time += 1;
    } completed:^{
        XCTAssert(time == 3);
        [ex2 fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0 handler:nil];

}

/// rac_liftSelector: withSignalsFromArray: 当数组里每个信号都sendnext一次后触发lift指定的方法
/// 每个信号都会触发lift方法,参数是每个信号最新的值
/// 和combineLatest:方法非常相似

- (void)testLift {
    [self.usage.lift1 sendNext:@"1"];
    NSArray *result = @[];
    XCTAssert([self.usage.liftResult isEqualToArray:result]);
    
    [self.usage.lift2 sendNext:@"2"];
    result = @[@[@"1",@"2"]];
    XCTAssert([self.usage.liftResult isEqualToArray:result]);
    
    [self.usage.lift1 sendNext:@"2"];
    result = @[@[@"1",@"2"],@[@"2",@"2"]];
    XCTAssert([self.usage.liftResult isEqualToArray:result]);

}

- (void)testObserve {
    __block float value = self.usage.slider.value;
    [RACObserve(self.usage.slider, value) subscribeNext:^(NSNumber *x) {
        value = x.floatValue;
    }];
    self.usage.slider.value = 0.5f;
    XCTAssert(value == 0.5f);
}

- (void)testSignalForEvent {
    __block float value = self.usage.slider.value;
    [[self.usage.slider rac_signalForControlEvents:UIControlEventValueChanged]
     subscribeNext:^(UISlider *x) {
         value = x.value;
    }];
    XCTAssert(value == 0.f);

    //手动设置value无法触发event，设计必须是界面触发event
    self.usage.slider.value = 0.5f;
    XCTAssert(value == 0.f);
    
//    XCTestExpectation *ex1 = [self expectationWithDescription:@"111"];
//    ex1.expectedFulfillmentCount = 1.0f;
//    [UIView animateWithDuration:0.2 animations:^{
//        self.usage.slider.value = 0.7f;
//    } completion:^(BOOL finished) {
//        [self.usage.slider sendActionsForControlEvents:UIControlEventValueChanged];
//        XCTAssert(value == 0.7f);
//        [ex1 fulfill];
//    }];
//    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

/// rac_signalForSelector: hook方法，然后把参数打包成RACTuple
- (void)testSignalForSelector {
    __block NSString *result;
    [[self.usage rac_signalForSelector:@selector(signalForSelectorResult:)]
     subscribeNext:^(RACTuple *x) {
         result = x.first;
     }];
    XCTAssert(result == nil);
    
    [self.usage signalForSelectorResult:@"10010"];
    XCTAssert([result isEqualToString:@"10010"]);
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
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

- (RACCommonUsage *)usage {
    if (!_usage) {
        _usage = [RACCommonUsage new];
    }
    return _usage;
}

@end
