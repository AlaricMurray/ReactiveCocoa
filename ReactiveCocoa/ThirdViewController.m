//
//  ThirdViewController.m
//  ReactiveCocoa
//
//  Created by 朱明灿 on 17/2/17.
//  Copyright © 2017年 张佳强. All rights reserved.
//

#import "ThirdViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//
//    [[self.userNameTextfield.rac_textSignal
//      filter:^BOOL(id value){
//          NSString*text = value;
//          return text.length > 3;
//      }]
//     subscribeNext:^(id x){
//             _buttonClick.enabled = NO;
//         
//         _buttonClick.enabled = YES;
//         
//     }];
//    [[self.userNameTextfield.rac_textSignal
//      filter:^BOOL(id value){
//          NSString*text = value;
//          return text.length <= 3;
//      }]
//     subscribeNext:^(id x){
//         _buttonClick.enabled = NO;
//         
//         
//     }];
    
    
//    
//    [[[self.userNameTextfield.rac_textSignal
//       map:^id(NSString*text){
//           return @(text.length);
//       }]
//      filter:^BOOL(NSNumber*length){
//          return[length integerValue] > 3;
//      }]
//     subscribeNext:^(id x){
//         NSLog(@"%@", x);
//     }];
    
    
//    创建信号，反应用户名是否合法
    RACSignal *validUsernameSignal =
    [self.userNameTextfield.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidUsername:text]);
     }];
    
//    创建信号，反应密码是否合法
    RACSignal *validPasswordSignal =
    [self.passwordTextfield.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidPassword:text]);
     }];
    
//   监听信号，改变userNameTextfield的背景色，若信号的数据反映用户名合法就将背景色设置为透明，若不合法，设置为黄色
    RAC(self.userNameTextfield, backgroundColor) =
    [validUsernameSignal
    map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
     }];
    
//    监听密码是否合法的信号
    RAC(self.passwordTextfield, backgroundColor) =
    [validPasswordSignal
     map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
     }];

//    聚合两个信号为一个信号，每次这两个源信号的任何一个产生新值时，reduce block都会执行，block的返回值会发给下一个信号
    RACSignal *signUpActiveSignal =
    [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal]
                      reduce:^id(NSNumber*usernameValid, NSNumber *passwordValid){
                          return @([usernameValid boolValue]&&[passwordValid boolValue]);
                      }];
    
//    将信号绑定在按钮的enable属性上
    [signUpActiveSignal subscribeNext:^(NSNumber*signupActive){
        self.buttonClick.enabled =[signupActive boolValue];
    }];
    
    
    //检查按钮是否可用
//    [[self.buttonClick
//      rac_signalForControlEvents:UIControlEventTouchUpInside]
//     subscribeNext:^(id x) {
//         NSLog(@"button clicked");
//     }];
    
    //    把按钮点击事件转换为登录信号，若为1用户名密码正确，可以跳转，0用户名或密码错误，不能跳转。
//    [[[self.buttonClick
//       rac_signalForControlEvents:UIControlEventTouchUpInside]
//      flattenMap:^id(id x){
//          return[self signInSignal];
//      }]
//     subscribeNext:^(id x){
//         NSLog(@"Sign in result: %@", x);
//     }];
    
    
//    实现按钮登录(方法一)
//    [[[self.buttonClick
//       rac_signalForControlEvents:UIControlEventTouchUpInside]
//      flattenMap:^id(id x){
//          return[self signInSignal];
//      }]
//     subscribeNext:^(NSNumber*signedIn){
//         BOOL success =[signedIn boolValue];
//         if(success){
//             [self dismissViewControllerAnimated:YES completion:nil];
//             
//         }
//     }];

    
//    实现按钮登录（方法二）doNext:是直接跟在按钮点击事件的后面。而且doNext: block并没有返回值。因为它是附加操作，并不改变事件本身。
    [[[[self.buttonClick
        rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(id x){
           self.buttonClick.enabled =NO;
           //提示用户名或密码不合法
       }]
      flattenMap:^id(id x){
          return[self signInSignal];
      }]
     subscribeNext:^(NSNumber*signedIn){
         self.buttonClick.enabled =YES;
         BOOL success =[signedIn boolValue];
//         根据success的值来判断登录是否成功
         
         
         if(success){
             [self dismissViewControllerAnimated:YES completion:nil];

         }
     }];
}

//创建信号，验证用户名和密码是否正确
- (RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id subscriber){
        [self
         signInWithUsername:self.userNameTextfield.text
         password:self.passwordTextfield.text
         complete:^(BOOL success){
             [subscriber sendNext:@(success)];
             [subscriber sendCompleted];
         }];
        return nil;
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_userNameTextfield resignFirstResponder];
    [_passwordTextfield resignFirstResponder];
}

-(BOOL)isValidUsername:(NSString *)str{
    if (str.length>4) {
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)isValidPassword:(NSString *)str{
    if (str.length>4) {
        return YES;
    }else{
        return NO;
    }
}

//设置登录的用户名和密码
- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(SignInResponse)completeBlock {
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        BOOL success = [username isEqualToString:@"username"] && [password isEqualToString:@"password"];
        completeBlock(success);
    });
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

- (IBAction)click:(id)sender {
}
@end
