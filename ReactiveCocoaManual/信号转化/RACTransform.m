//
//  RACTransform.m
//  ReactiveCocoaManual
//
//  Created by ray on 2017/8/12.
//  Copyright © 2017年 ray. All rights reserved.
//

#import "RACTransform.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACTransform ()

@end

@implementation RACTransform



- (RACSubject *)footerSubject {
    if (!_footerSubject) {
        _footerSubject = [RACSubject subject];
    }
    return _footerSubject;
}

- (RACSubject *)headSubject {
    if (!_headSubject) {
        _headSubject = [RACSubject subject];
    }
    return _headSubject;
}

@end
