//
//  ZHTextView.m
//  RichText
//
//  Created by wzh on 2019/1/24.
//  Copyright © 2019 ZH. All rights reserved.
//

#import "ZHTextView.h"
#import "ZHRichTextParser.h"

@interface ZHTextView ()<UITextViewDelegate>
@property (nonatomic, copy) NSString *plainString;
///富文本处理类
@property (nonatomic, strong) ZHRichTextParser *textParser;
@end

@implementation ZHTextView
- (ZHRichTextParser *)textParser
{
    if (!_textParser) {
        _textParser = [[ZHRichTextParser alloc] init];
    }
    return _textParser;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:16.f];
        self.textColor = [UIColor blackColor];
        self.contentMode = UIViewContentModeRedraw;
        self.dataDetectorTypes = UIDataDetectorTypeNone;
        self.layer.cornerRadius = 5.0f;
        self.returnKeyType = UIReturnKeySend;
        self.enablesReturnKeyAutomatically = YES;
        self.delegate = self;
        if (@available(iOS 11.0, *)) {  // 只在iOS11及以上才有这个属性
            self.textDragInteraction.enabled = NO;//关闭图片拖拽
        }
        self.plainString = @"";
        
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
#pragma mark - 重写系统方法
- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}
- (BOOL)resignFirstResponder
{
    BOOL isResign = [super resignFirstResponder];
    if (isResign) {
        self.inputView = nil;
        if ([self.customDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
            [self.customDelegate textViewDidEndEditing:self];
        }        
    }
    return isResign;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.customDelegate respondsToSelector:@selector(textViewShouldBeginEditing)]) {
        return [self.customDelegate textViewShouldBeginEditing];
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *string = [self.textParser stringWithAttributedString:self.attributedText];
    self.plainString = string;
    if ([self.customDelegate respondsToSelector:@selector(textView:changeText:)]) {
        [self.customDelegate textView:self changeText:self.plainString];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self sendText];
        return NO;
        
    }else{
        return YES;
        
    }
}
#pragma mark - 重写复制黏贴剪切等事件
- (void)copy:(id)sender{
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    if (self.attributedText) {
        NSAttributedString *attributedText = [self.attributedText attributedSubstringFromRange:self.selectedRange];
        NSString *string = [self.textParser stringWithAttributedString:attributedText];
        self.plainString = string;
        pasteBoard.string = self.plainString;
    }
    self.font = [UIFont systemFontOfSize:16];
    
}
- (void)cut:(nullable id)sender{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    if (self.attributedText) {
        NSAttributedString *attributedText = [self.attributedText attributedSubstringFromRange:self.selectedRange];
        NSString *string = [self.textParser stringWithAttributedString:attributedText];
        pasteBoard.string = string;
        
        
        NSMutableAttributedString *newAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        [newAttributedText deleteCharactersInRange:self.selectedRange];
        self.attributedText = newAttributedText;
        
        NSMutableString *tempString = [[NSMutableString alloc] initWithString:self.plainString];
        NSRange subRange = [self.plainString rangeOfString:string];
        [tempString deleteCharactersInRange:subRange];
        self.plainString = tempString;
    }
    if (@available(iOS 9.0, *)) {}else
    {//适配iOS 8
        NSString *cutString = pasteBoard.string.mutableCopy;
        [super cut:sender];
        pasteBoard.string = cutString;
    }
    
}

- (void)paste:(id)sender{
    if (@available(iOS 9.0, *)) {}else
    {//适配iOS 8
        [super paste:sender];
    }
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    if (pasteBoard.string) {
        // 记住当前的光标位置
        NSRange selectedRange = self.selectedRange;
        NSUInteger length = 0;
        if (@available(iOS 9.0, *)) {
            //处理黏贴富文本,例如：[大笑]
            NSAttributedString *subAttStr = [self.textParser attributedStringWithString:pasteBoard.string];
            NSMutableAttributedString *newAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
            [newAttributedText insertAttributedString:subAttStr atIndex:self.selectedRange.location];
            NSString *string = [self.textParser stringWithAttributedString:newAttributedText];
            self.plainString = string;
            length = subAttStr.length;
        }
        self.attributedText = [self.textParser attributedStringWithInputString:self.plainString];
        
        // 重新设置光标
        self.selectedRange = NSMakeRange(selectedRange.location+length, 0);
    }
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        if ([self.customDelegate respondsToSelector:@selector(textView:contentHeightShouldChange:)]) {
            CGFloat contentHeight = self.contentSize.height;
            [self.customDelegate textView:self contentHeightShouldChange:contentHeight];
        }
        [self scrollRangeToVisible:NSMakeRange(self.attributedText.length, 1)];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark - seter
- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    self.font = [UIFont systemFontOfSize:16];
}
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.textParser.font = font;
}
- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    self.textParser.defaultColor = textColor;
}
- (void)setPlainString:(NSString *)plainString
{
    _plainString = plainString;
    
    if ([self.customDelegate respondsToSelector:@selector(textView:changeText:)]) {
        [self.customDelegate textView:self changeText:plainString];
    }
}

#pragma mark - 外部方法
- (void)switchKeyboard:(ZHKeyboardType)keyboardType
{
    switch (keyboardType) {
        case ZHKeyboardTypeDefualt:
            self.inputView = nil;
            break;
        case ZHKeyboardTypeFace:
            self.inputView = self.customKeyboardView;
            break;
        default:
            
            break;
    }
    [self reloadInputViews];
    
    if (!self.isFirstResponder) {
        [self becomeFirstResponder];
    }

}
- (void)appendingEmoticon:(NSString *)emoticon
{
    if (emoticon) {
        self.plainString = [self.plainString stringByAppendingString:emoticon];;
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        NSAttributedString *subAttributedText = [self.textParser attributedStringWithInputString:emoticon];
        NSRange range = self.selectedRange;
        
        [attributedText insertAttributedString:subAttributedText atIndex:range.location];
        self.attributedText = attributedText;
        range.location = range.location + subAttributedText.length;
        self.selectedRange = NSMakeRange(range.location,0);//改变输入位置
    }
}
- (void)appendingString:(NSString *)string
{
    if (string) {
        self.plainString = [self.plainString stringByAppendingString:string];;
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        NSAttributedString *subAttributedText = [[NSAttributedString alloc] initWithString:string];
        NSRange range = self.selectedRange;
        
        [attributedText insertAttributedString:subAttributedText atIndex:range.location];
        self.attributedText = attributedText;
        range.location = range.location + subAttributedText.length;
        self.selectedRange = NSMakeRange(range.location,0);//改变输入位置
    }
}
- (void)deleteEmoticon
{
    if (self.attributedText.length) {
        NSMutableAttributedString *attributedText = [self.attributedText mutableCopy];
        NSRange range = NSMakeRange(attributedText.length - 1, 1);
        
        NSAttributedString *subAttributedText = [self.attributedText attributedSubstringFromRange:range];
        NSString *subString = [self.textParser stringWithAttributedString:subAttributedText];
        NSMutableString *plainString = [self.plainString mutableCopy];
        NSRange subRange = [plainString rangeOfString:subString options:NSBackwardsSearch];
        [plainString deleteCharactersInRange:subRange];
        self.plainString = plainString;
        
        [attributedText deleteCharactersInRange:range];
        self.attributedText = attributedText;
    }
}
- (void)sendText
{
    if ([self.customDelegate respondsToSelector:@selector(textView:sendText:)]) {
        BOOL isSend = [self.customDelegate textView:self sendText:self.plainString];
        if (isSend) {
            self.text = nil;
            self.plainString = @"";
            self.attributedText = nil;
            
        }
    }
}
- (void)clearContent
{
    self.text = nil;
    self.plainString = @"";
    self.attributedText = nil;
}
@end
