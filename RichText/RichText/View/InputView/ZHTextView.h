//
//  ZHTextView.h
//  RichText
//
//  Created by wzh on 2019/1/24.
//  Copyright © 2019 ZH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHTextView;


typedef NS_OPTIONS(NSInteger, ZHKeyboardType){
    ZHKeyboardTypeDefualt,  //默认系统键盘
    ZHKeyboardTypeFace,     //表情键盘
};


@protocol ZHTextViewDelegate <NSObject>

@optional
- (void)textView:(ZHTextView *)textView contentHeightShouldChange:(CGFloat)contentHeight;
- (BOOL)textView:(ZHTextView *)textView sendText:(NSAttributedString *)text;
- (void)textView:(ZHTextView *)textView changeText:(NSString *)text;
- (BOOL)textViewShouldBeginEditing;
- (void)textViewDidEndEditing:(ZHTextView *)textView;
@end

@interface ZHTextView : UITextView
@property (nonatomic, weak) id<ZHTextViewDelegate> customDelegate;
///自定义键盘
@property (nonatomic,strong) UIView *customKeyboardView;

/**
 切换键盘

 @param keyboardType 键盘类型
 */
- (void)switchKeyboard:(ZHKeyboardType)keyboardType;
/**
 拼接表情
 
 @param emoticon 表情描述字符串
 */
- (void)appendingEmoticon:(NSString *)emoticon;

/**
 依次删除表情
 */
- (void)deleteEmoticon;

/**
 拼接普通字符串
 
 @param string 字符串
 */
- (void)appendingString:(NSString *)string;
///清空输入框内容
- (void)clearContent;
///发送文本
- (void)sendText;
@end

