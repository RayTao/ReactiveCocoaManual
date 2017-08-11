//
//  HotColdObservable.h
//  ReactiveCocoaManual
//
//  Created by ray on 15/11/24.
//  Copyright © 2015年 ray. All rights reserved.
//

#import "XKO_ViewModel.h"

/**
 *  理解冷信号和热信号的用法
 
 *  1.Hot Observable是主动的，尽管你并没有订阅事件，但是它会时刻推送，就像鼠标移动；而Cold Observable是被动的，只有当你订阅的时候，它才会发布消息。
 
 *  2.Hot Observable可以有多个订阅者，是一对多，集合可以与订阅者共享信息；而Cold Observable只能一对一，当有不同的订阅者，消息是重新完整发送。
 */
@interface HotColdObservable : XKO_ViewModel

/**
 *  冷信号是被动的，只有当你订阅的时候，它才会发送消息.
 *  而冷信号只能一对一，当有不同的订阅者，消息会从新完整发送
 */
- (void)coldObservableTest;

/**
 *  热信号是主动的，即使你没有订阅事件，它仍然会时刻推送.
 *  热信号可以有多个订阅者，是一对多，信号可以与订阅者共享信息
 */
- (void)hotObservableTest;

/**
 *  在冷信号中任何的信号转换即是对原有的信号进行订阅从而产生新的信号
 */
- (void)whyHotObservable;

@end
