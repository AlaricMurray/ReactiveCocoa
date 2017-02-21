//
//  ThirdViewController.h
//  ReactiveCocoa
//
//  Created by 朱明灿 on 17/2/17.
//  Copyright © 2017年 张佳强. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SignInResponse)(BOOL);

@interface ThirdViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *userNameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (strong, nonatomic) IBOutlet UIButton *buttonClick;
- (IBAction)click:(id)sender;
- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(SignInResponse)completeBlock;
@end
