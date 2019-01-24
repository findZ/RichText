//
//  ViewController.m
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import "ViewController.h"
#import "ZHRichTextParser.h"
#import "ZHRichView.h"

@interface ViewController ()<ZHRichViewDelegate>
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    NSString *text = @"iOS[可爱][微笑]794412987@qq.com你好啊[惊讶]你好啊[惊讶]www.baidu.com[惊讶][惊讶][大哭]18255552287[害羞]啦啦啦啦啦[得意][敲打][再见]iOS[可爱][微笑]794412987@qq.com你好啊[惊讶]你好啊[惊讶]www.baidu.com[惊讶][惊讶][大哭]18255552287[害羞]啦啦啦啦啦[得意][敲打][再见]iOS[可爱][微笑]794412987@qq.com你好啊[惊讶]你好啊[惊讶]www.baidu.com[惊讶][惊讶][大哭]18255552287[害羞]啦啦啦啦啦[得意][敲打][再见]iOS[可爱][微笑]794412987@qq.com你好啊[惊讶]你好啊[惊讶]www.baidu.com[惊讶][惊讶][大哭]18255552287[害羞]啦啦啦啦啦[得意][敲打][再见]iOS[可爱][微笑]794412987@qq.com你好啊[惊讶]你好啊[惊讶]www.baidu.com[惊讶][惊讶][大哭]18255552287[害羞]啦啦啦啦啦[得意][敲打][再见]";
    ZHRichView *richView =  [[ZHRichView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 300)];
    richView.delegate = self;
    richView.backgroundColor = [UIColor lightTextColor];
    richView.text = text;
    [self.view addSubview:richView];
    
}

#pragma mark - ZHRichViewDelegate
- (void)didClickLinkWithUrlString:(NSString *)urlString
{
    NSLog(@"%@",urlString);
}
- (void)didClickLinkWithEmailString:(NSString *)emailAddress
{
    NSLog(@"%@",emailAddress);
}

- (void)didClickLinkWithPhoneNumberString:(NSString *)phoneNumber
{
    NSLog(@"%@",phoneNumber);
}

@end
