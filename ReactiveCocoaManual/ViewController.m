//
//  ViewController.m
//  ReactiveCocoaManual
//
//  Created by ray on 15/11/24.
//  Copyright © 2015年 ray. All rights reserved.
//

#import "ViewController.h"
#import "HotColdObservable.h"
#import "Command.h"


@interface ViewController ()

@property (nonatomic, weak) UIButton *mybutton;
@property (nonatomic, strong) id viewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self.view.rac];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    button.backgroundColor = [UIColor redColor];
    self.mybutton = button;
    [self.view addSubview:self.mybutton];
    
//    [self HotColdSignal];
    [self commandTest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mybutton.backgroundColor = [UIColor greenColor];
    });
}

- (void)commandTest {
    Command *test = [[Command alloc] init];
    self.viewModel = test;
    [[[test.testCommand executionSignals] switchToLatest] subscribeNext:^(id x) {
        NSLog(@"next: %@",x);
    } error:^(NSError *error) {
        NSLog(@"doerror:%@",error);
    }];
    
    [test.testCommand execute:@"233"];
    //连续的两个/多个execute，只有第一个会被执行
    [test.testCommand execute:@"一个command无法同时执行多个execute，只有第一个会被执行"];
    
    
    [[[test.materializeCommand executionSignals] switchToLatest] subscribeNext:^(RACEvent *x) {
        if (x.eventType == RACEventTypeNext) {
            NSLog(@"next: %@",x.value);
        } else if (x.eventType == RACEventTypeCompleted) {
            NSLog(@"Complete");
        } else if (x.eventType == RACEventTypeError) {
            NSLog(@"error: %@",x.error);
        }
    }];
    
    [test.materializeCommand execute:@"materialize 0000"];
    [test.materializeCommand execute:@"一个command无法同时执行多个execute，只有第一个会被执行"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [test.testCommand execute:nil];
        [test.materializeCommand execute:nil];
    });
    
    
}

- (void)HotColdSignal {
    HotColdObservable *hotColdObservable = [[HotColdObservable alloc] init];
    [hotColdObservable hotObservableTest];
    [hotColdObservable coldObservableTest];
}




@end
