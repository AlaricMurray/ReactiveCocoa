//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by 朱明灿 on 17/2/17.
//  Copyright © 2017年 张佳强. All rights reserved.
//



//CocoaPods 安装ReactiveCocoa，Podfile里写：
//use_frameworks!
//target 'ReactiveCocoa' do
//pod 'ReactiveCocoa','~> 4.0.2-alpha-1'


#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SecondViewController.h"
@interface ViewController ()
@property (nonatomic , strong)UILabel * label;
@property (nonatomic , weak)RACCommand * command;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //核心类RACSignal的使用
    
    // RACSignal使用步骤：
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 - (void)sendNext:(id)value
    
    
    // RACSignal底层实现：
    // 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
    // 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
    // 2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
    // 2.1 subscribeNext内部会调用siganl的didSubscribe
    // 3.siganl的didSubscribe中调用[subscriber sendNext:@1];
    // 3.1 sendNext底层其实就是执行subscriber的nextBlock
    
    
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号被销毁");
        }];
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"接受到的数据是：%@",x);
    }];
    
    //    RACSubject
    
    // RACSubject使用步骤
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 sendNext:(id)value
    
    // RACSubject:底层实现和RACSignal不一样。
    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    
    
    RACSubject * subject = [RACSubject subject];
    [subject subscribeNext:^(id x) {
        NSLog(@"the first is:%@",x);
    }];
    [subject subscribeNext:^(id x) {
        NSLog(@"the second is:%@",x);
    }];
    [subject sendNext:@"1"];
    
    
    //    RACReplaySubject
    
    
    // RACReplaySubject使用步骤:
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.可以先订阅信号，也可以先发送信号。
    // 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 2.2 发送信号 sendNext:(id)value
    
    // RACReplaySubject:底层实现和RACSubject不一样。
    // 1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    // 2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
    
    // 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    // 也就是先保存值，在订阅值。
    
    
    RACReplaySubject * replaySubject = [RACReplaySubject subject];
    [replaySubject sendNext:@2];
    [replaySubject sendNext:@3];
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"El numero uno es:%@",x);
    }];
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"El numero dos es:%@",x);
    }];
    
    
    //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(50, 100, 80, 60);
    button.backgroundColor = [UIColor yellowColor];
    [button setTitle:@"Click" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(80, 230, 100, 40)];
    _label.backgroundColor = [UIColor redColor];
    [self.view addSubview:_label];
    
    //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
    //遍历数组
    NSArray * array = @[@"uno",@"dos",@"tres"];
    [array.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    //    遍历字典
    NSDictionary * dict = @{@"red":@"rojo",@"white":@"blanco"};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        // 相当于以下写法
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        
        NSLog(@"%@ %@",key,value);
        
    }];
    
    // 3.3 RAC高级写法:
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    
    
    //    NSArray *flags = [[dictArr.rac_sequence map:^id(id value) {
    //
    //        return [FlagItem flagWithDict:value];
    //
    //    }] array];
    
    
    
    
    RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        NSLog(@"执行命令");
        NSLog(@"-->%@",input);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    //    强引用，不要被销毁，否则接收不到数据
    _command = command;
    
    [command.executionSignals subscribeNext:^(id x) {
        [x subscribeNext:^(id x) {
            NSLog(@"~>%@",x);
        }];
    }];
    // 4.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
        
    }];
    // 5.执行命令,execute后的参数input会作为创建command时其内部signal的构建block中的参数，用于传递数据。
    [_command execute:@"http://www.baidu.com"];
    
}

//步骤三：在第一个控制器中，监听跳转按钮，给第二个控制器的代理信号赋值，并且监听.
-(void)click:(UIButton *)button{
    
    SecondViewController * second =[[SecondViewController alloc]init];
    // 设置代理信号
    
    second.delegateSignal = [RACSubject subject];
    // 订阅代理信号
    
    [second.delegateSignal subscribeNext:^(id x) {
        //        _label.text = [NSString stringWithFormat:@"%@",x];
        self.view.backgroundColor = [UIColor colorWithRed:arc4random()%254/255.0 green:arc4random()%254/255.0 blue:arc4random()%254/255.0 alpha:1.0];
    }];
    [self presentViewController:second animated:YES completion:^{
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
