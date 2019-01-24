//
//  ViewController.m
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import "ViewController.h"
#import "ZHRichView.h"
#import "ZHTextView.h"

@interface ViewController ()<ZHRichViewDelegate, ZHTextViewDelegate>
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    NSString *text = @"iOS[可爱][微笑]794412987@qq.com你好啊[惊讶]你好啊[惊讶]www.baidu.com[惊讶][惊讶][大哭]18255552287[害羞]啦啦啦啦啦[得意][敲打][再见]iOS[可爱][微笑]794412987@qq.com你好啊[惊讶]你好啊[惊讶]www.baidu.com[惊讶][惊讶][大哭]18255552287[害羞]啦啦啦啦啦[得意]";
    ZHRichView *richView =  [[ZHRichView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 200)];
    richView.delegate = self;
    richView.text = text;
    [self.view addSubview:richView];
    
    ZHTextView *textView = [[ZHTextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(richView.frame)+10, self.view.bounds.size.width, 44)];
    textView.customDelegate = self;
    textView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:textView];
    
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


#pragma mark - ZHTextViewDelegate
- (void)textView:(ZHTextView *)textView contentHeightShouldChange:(CGFloat)contentHeight
{
    if (contentHeight < 80) {
        CGRect frame = textView.frame;
        textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, contentHeight);        
    }
}
@end
