//
//  RACTransform.h
//  ReactiveCocoaManual
//
//  Created by ray on 2017/8/12.
//  Copyright © 2017年 ray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSubject;

@interface RACTransform : NSObject
@property (nonatomic, strong) RACSubject *headSubject;
@property (nonatomic, strong) RACSubject *footerSubject;

@end
