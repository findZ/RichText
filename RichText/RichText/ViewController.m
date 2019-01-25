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


#define K_TextViewHeight 44
#define K_ScreenSize  [UIScreen mainScreen].bounds.size


@interface ViewController ()<ZHRichViewDelegate, ZHTextViewDelegate>
@property (nonatomic, weak) ZHRichView *richView;
@property (nonatomic, weak) ZHTextView *textView;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupSubView];
    
}
- (void)setupSubView
{
    NSString *text = @"iOS[可爱][微笑]794412987@qq.com你好啊[惊讶]你好啊[惊讶]www.baidu.com[惊讶][惊讶][大哭]18255552287[害羞]啦啦啦啦啦[得意][敲打][再见]iOS[可爱][微笑]794412987@qq.com你好啊[惊讶]你好啊[惊讶]www.baidu.com[惊讶][惊讶][大哭]18255552287[害羞]啦啦啦啦啦[得意]";
    ZHRichView *richView =  [[ZHRichView alloc] initWithFrame:CGRectMake(0, 20, K_ScreenSize.width, 100)];
    richView.delegate = self;
    richView.text = text;
    [self.view addSubview:richView];
    self.richView = richView;
    
    ZHTextView *textView = [[ZHTextView alloc] initWithFrame:CGRectMake(0, K_ScreenSize.height - 44, K_ScreenSize.width, K_TextViewHeight)];
    textView.customDelegate = self;
//    textView.backgroundColor = [UIColor lightGrayColor];
//    textView.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_ScreenSize.width, K_TextViewHeight)];
//    textView.inputAccessoryView.backgroundColor = [UIColor purpleColor];
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//    btn.backgroundColor = [UIColor redColor];
//    [textView.inputAccessoryView addSubview:btn];
    
    [self.view addSubview:textView];
    self.textView = textView;
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

}
- (BOOL)textView:(ZHTextView *)textView sendText:(NSString *)text
{
    self.richView.text = text;
    return YES;
}
#pragma mark - 键盘
- (void)keyBoardWillShow:(NSNotification *)not
{
    CGRect keyBoardFrame = [not.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.textView.frame = CGRectMake(0, keyBoardFrame.origin.y - K_TextViewHeight, self.view.bounds.size.width, K_TextViewHeight);
}
- (void)keyBoardDidHide:(NSNotification *)not
{
    CGRect keyBoardFrame = [not.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.textView.frame = CGRectMake(0, keyBoardFrame.origin.y - K_TextViewHeight, self.view.bounds.size.width, K_TextViewHeight);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
