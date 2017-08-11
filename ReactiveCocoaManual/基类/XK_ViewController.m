//
//  XK_ViewController.m
//  jingGang
//
//  Created by ray on 15/10/20.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "XK_ViewController.h"

#import "AppDelegate.h"

@interface XK_ViewController () <UIAlertViewDelegate>

@end

@implementation XK_ViewController
#define KInvalidTokenErrorCode     @"您的账号已失效,请重新登录!"
#define Token @"access_token"
#define status_color  [UIColor colorWithRed:74.0/255 green:182.0/255 blue:236.0/255 alpha:1]

- (void)dealloc {
    NSLog(@"dealloc--%@",[self class]);
//    [self.vapiManager.operationQueue cancelAllOperations];
//    [self.viewModel.client.vapiManager.operationQueue cancelAllOperations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bindViewModel];
    [self setUIAppearance];
}

- (void)setUIAppearance {
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor whiteColor];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    navBar.translucent = NO;
    navBar.barTintColor = status_color;
}

- (void)bindViewModel {
    @weakify(self);
    RAC(self,title) = RACObserve(self.viewModel, title);
    [RACObserve(self.viewModel, isExcuting) subscribeNext:^(NSNumber *isExcuting) {
//        @strongify(self);
//        if ([isExcuting boolValue]) {
//            [self.view showLoading];
//        }
//        else    [self.view hideLoading];
    }];
    [[RACObserve(self.viewModel, error) filter:^BOOL(NSError *value) {
        return value != nil;
    }] subscribeNext:^(NSError *error) {
        @strongify(self);
        if (self.closeDefaultErrorInform) return;
    }];
}

- (void)specErrorHandle:(NSError *)error {

}

- (void)errorHandle:(NSError *)error {

}

- (XKO_ViewModel *)viewModel {
    return nil;
}


@end
