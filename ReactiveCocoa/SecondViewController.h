//
//  SecondViewController.h
//  ReactiveCocoa
//
//  Created by 朱明灿 on 17/2/17.
//  Copyright © 2017年 张佳强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface SecondViewController : UIViewController
//ReactiveCocoa代理传值

//步骤一：在第二个控制器.h，添加一个RACSubject代替代理。

@property (nonatomic , strong)RACSubject * delegateSignal;
@end
