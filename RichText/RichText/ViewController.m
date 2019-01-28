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
#import "ZHEmotionTool.h"
#import "ZHEmotion.h"
#import "ZHEmotionsView.h"


#define K_TextViewHeight 44
#define K_ToolBarHeight  49
#define K_ScreenSize  [UIScreen mainScreen].bounds.size


@interface ViewController ()<ZHRichViewDelegate, ZHTextViewDelegate, ZHEmotionsViewDelegate>
@property (nonatomic, weak) ZHRichView *richView;
@property (nonatomic, weak) UIView *toolBar;
@property (nonatomic, weak) ZHTextView *textView;
@property (nonatomic, weak) UIButton *faceBtn;
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
    
    ZHTextView *textView = [[ZHTextView alloc] initWithFrame:CGRectMake(0, 2.5, K_ScreenSize.width - K_ToolBarHeight, K_TextViewHeight)];
    textView.customDelegate = self;
    
    ZHEmotionsView *view = [[ZHEmotionsView alloc] initWithFrame:CGRectMake(0, 0, K_ScreenSize.width,260)];
    view.delegate = self;
    textView.customKeyboardView = view;
    
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, K_ScreenSize.height - K_ToolBarHeight, K_ScreenSize.width, K_ToolBarHeight)];
    toolBar.backgroundColor = [UIColor orangeColor];
    UIButton *faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textView.frame), 0, K_ToolBarHeight, K_ToolBarHeight)];
    ZHEmotion *emotionNormal = [ZHEmotionTool emotionWithDesc:@"[微笑]"];
    ZHEmotion *emotionSelected = [ZHEmotionTool emotionWithDesc:@"[可爱]"];

    [faceBtn setImage:emotionNormal.image forState:UIControlStateNormal];
    [faceBtn setImage:emotionSelected.image forState:UIControlStateSelected];
    
    [faceBtn addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:textView];
    [toolBar addSubview:faceBtn];
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    self.textView = textView;
    self.faceBtn = faceBtn;
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
- (void)textViewDidEndEditing:(ZHTextView *)textView
{
    self.faceBtn.selected = NO;
}
#pragma mark - 键盘
- (void)keyBoardWillShow:(NSNotification *)not
{
    CGFloat duration = [not.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        CGRect keyBoardFrame = [not.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.toolBar.frame = CGRectMake(0, keyBoardFrame.origin.y - K_ToolBarHeight, self.view.bounds.size.width, K_ToolBarHeight);
    }];
}
- (void)keyBoardDidHide:(NSNotification *)not
{
    CGRect keyBoardFrame = [not.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.toolBar.frame = CGRectMake(0, keyBoardFrame.origin.y - K_ToolBarHeight, self.view.bounds.size.width, K_ToolBarHeight);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)faceBtnClick:(UIButton *)btn
{
    btn.selected = !btn.isSelected;
    
    if (btn.selected) {
        [self.textView switchKeyboard:ZHKeyboardTypeFace];
    }else{
        [self.textView switchKeyboard:ZHKeyboardTypeDefualt];
    }
}

#pragma mark - ZHEmotionsViewDelegate
- (void)didSelectedEmotion:(ZHEmotion *)emotion
{
    if (emotion.type == ZHEmotionTypeDelete) {
        [self.textView deleteEmoticon];
    }else{
        [self.textView appendingEmoticon:emotion.chs];
    }
}
- (void)didSelectSendButton:(UIButton *)sendButton
{
    [self.textView sendText];
}
@end
