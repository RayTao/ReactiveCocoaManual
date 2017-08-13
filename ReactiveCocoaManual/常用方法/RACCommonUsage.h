//
//  RACCommonUsage.h
//  ReactiveCocoaManual
//
//  Created by ray on 2017/8/12.
//  Copyright © 2017年 ray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RACSubject;

@interface RACCommonUsage : NSObject
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) RACSubject *lift1;
@property (nonatomic, strong) RACSubject *lift2;

- (NSArray *)liftResult;
- (void)signalForSelectorResult:(NSString *)input;

@end
