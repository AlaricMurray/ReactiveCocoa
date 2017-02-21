//
//  SecondViewController.m
//  ReactiveCocoa
//
//  Created by 朱明灿 on 17/2/17.
//  Copyright © 2017年 张佳强. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"
@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(50, 100, 80, 60);
    button.backgroundColor = [UIColor yellowColor];
    [button setTitle:@"Click" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(50, 200, 80, 60);
    button2.backgroundColor = [UIColor grayColor];
    [button2 setTitle:@"Login" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}

-(void)click:(UIButton *)nutton{
//    步骤二：监听第二个控制器按钮点击
// 判断代理信号是否有值
    if (self.delegateSignal) {
        // 有值，才需要通知,可传入数组等参数
        [self.delegateSignal sendNext:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void)login:(UIButton *)button{
    
    ThirdViewController * third = [[ThirdViewController alloc]init];
    [self presentViewController:third animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
