//
//  RACCommonUsage.m
//  ReactiveCocoaManual
//
//  Created by ray on 2017/8/12.
//  Copyright © 2017年 ray. All rights reserved.
//

#import "RACCommonUsage.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACCommonUsage ()

@property (nonatomic, strong) NSMutableArray *liftArray;
@end

@implementation RACCommonUsage

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lift1 = [RACSubject subject];
        _lift2 = [RACSubject subject];
        [self rac_liftSelector:@selector(recieveLift1:lift2:) withSignalsFromArray:@[_lift1,_lift2]];
        _liftArray = @[].mutableCopy;
        
    }
    return self;
}

- (void)recieveLift1:(id)lift1 lift2:(id)lift2 {
    [self.liftArray addObject:@[lift1,lift2]];
}

- (NSArray *)liftResult {
    return self.liftArray.copy;
}

- (void)signalForSelectorResult:(NSString *)input {}
- (void)valueDidChanged:(UISlider *)slider {
    NSLog(@"%@",slider);
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _slider.continuous = true;
        [_slider addTarget:self action:@selector(valueDidChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

@end
