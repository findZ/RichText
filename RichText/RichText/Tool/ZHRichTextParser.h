//
//  ZHRichTextParser.h
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


///富文本里面出现的链接
static NSString *const ZHRichLinkUrl = @"ZHRichLinkUrl";
///富文本里面出现的电话号码
static NSString *const ZHRichPhoneNumber = @"ZHRichPhoneNumber";
///富文本里面出现的邮箱地址
static NSString *const ZHRichEmailAddress = @"ZHRichEmailAddress";
///富文本里面出现的表情
static NSString *const ZHRichEmotion = @"ZHRichEmotion";

///自定义表情
#define K_EmotionRegex @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"
///链接地址
#define K_URLRegex  @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
///电话号码
#define K_PhoneNumberRegex @"(\\d{7,20}|((\\+\\d{2}-)?0\\d{2,3}-\\d{7,8})|400((-|[ ])\\d{3,4}){2}|800((-|[ ])\\d{3,4}){2}|((\\+\\d{2,4}-)?(\\d{2,4}-)?([1][3-9][0-9](-|[ ])?\\d{4}(-|[ ])?\\d{4})))"
///邮箱地址
#define K_EmailAddressRegex @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"


@interface ZHRichTextParser : NSObject
///字号
@property (nonatomic, strong) UIFont *font;
///默认文本颜色:blackColor
@property (nonatomic, strong) UIColor *defaultColor;
///默认自定义链接颜色:blueColor
@property (nonatomic, strong) UIColor *defaultLinkColor;


/**
 普通文本转换成富文本

 @param string 普通文本内容
 @return 富文本
 */
- (NSAttributedString *)attributedStringWithString:(NSString *)string;

/**
 将输入通过键盘输入的文本转换为富文本（包含自定义表情的输入内容）

 @param inputString 输入的文本
 @return 富文本
 */
- (NSAttributedString *)attributedStringWithInputString:(NSString *)inputString;
///把富文本转换为普通文字
- (NSString *)stringWithAttributedString:(NSAttributedString *)attributedString;
@end

