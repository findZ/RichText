//
//  ZHRichTextParser.m
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import "ZHRichTextParser.h"
#import "ZHRegexResult.h"
#import "ZHEmotionTool.h"
#import "ZHTextAttachment.h"
#import "ZHEmotion.h"

@implementation ZHRichTextParser
#pragma mark - geter
- (UIColor *)defaultLinkColor
{
    if (!_defaultLinkColor) {
        _defaultLinkColor = [UIColor blueColor];
    }
    return _defaultLinkColor;
}
- (UIFont *)font
{
    if (!_font) {
        _font = [UIFont systemFontOfSize:16];
    }
    return _font;
}
- (UIColor *)defaultColor
{
    if (!_defaultColor) {
        _defaultColor = [UIColor blackColor];
    }
    return _defaultColor;
}
#pragma mark - 内部方法
/**
 *  根据字符串计算出所有的匹配结果
 *
 *  @param text 字符串内容
 */
- (NSArray *)regexResultsWithRegula:(NSString *)regula text:(NSString *)text
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regula                                                                           options:NSRegularExpressionCaseInsensitive                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:text options:NSMatchingReportCompletion range:NSMakeRange(0, [text length])];
    return arrayOfAllMatches;
}
//匹配表情
- (NSArray *)regexResultEmotion:(NSString *)text
{
    //1,用来存放所有的匹配结果
    NSMutableArray *regexResults = [NSMutableArray arrayWithCapacity:5];
    
    //2,匹配表情
    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    
    NSArray *arrayOfAllMatches = [self regexResultsWithRegula:emotionRegex text:text];
    [arrayOfAllMatches enumerateObjectsUsingBlock:^(NSTextCheckingResult *match, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *substringForMatch = [text substringWithRange:match.range];
        ZHRegexResult *regexResult = [[ZHRegexResult alloc] init];
        regexResult.string = substringForMatch;
        regexResult.range = match.range;
        regexResult.emotion = YES;
        regexResult.type = ZHRegexResultTypeEmotion;
        [regexResults addObject:regexResult];
    }];
    return regexResults;
}
//匹配链接
- (NSArray *)regexResultUrl:(NSString *)text
{
    //用来存放所有的匹配结果
    NSMutableArray *regexResults = [NSMutableArray arrayWithCapacity:5];
    
    NSArray *urlArray = [self regexResultsWithRegula:K_URLRegex text:text];
    [urlArray enumerateObjectsUsingBlock:^(NSTextCheckingResult *match, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *substringForMatch = [text substringWithRange:match.range];
        ZHRegexResult *regexResult = [[ZHRegexResult alloc] init];
        regexResult.string = substringForMatch;
        regexResult.range = match.range;
        regexResult.type = ZHRegexResultTypeURL;
        [regexResults addObject:regexResult];
    }];
    return regexResults;
}
//匹配电话号码
- (NSArray *)regexResultPhoneNumber:(NSString *)text
{
    //用来存放所有的匹配结果
    NSMutableArray *regexResults = [NSMutableArray arrayWithCapacity:5];
 
    NSArray *phoneArray = [self regexResultsWithRegula:K_PhoneNumberRegex text:text];
    [phoneArray enumerateObjectsUsingBlock:^(NSTextCheckingResult *match, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *substringForMatch = [text substringWithRange:match.range];
        ZHRegexResult *regexResult = [[ZHRegexResult alloc] init];
        regexResult.string = substringForMatch;
        regexResult.range = match.range;
        regexResult.type = ZHRegexResultTypePhoneNumber;
        [regexResults addObject:regexResult];
    }];
    return regexResults;
}
//匹配邮箱
- (NSArray *)regexResultEmail:(NSString *)text
{
    //用来存放所有的匹配结果
    NSMutableArray *regexResults = [NSMutableArray arrayWithCapacity:5];
    
    NSArray *emailArray = [self regexResultsWithRegula:K_EmailAddressRegex text:text];
    [emailArray enumerateObjectsUsingBlock:^(NSTextCheckingResult *match, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *substringForMatch = [text substringWithRange:match.range];
        ZHRegexResult *regexResult = [[ZHRegexResult alloc] init];
        regexResult.string = substringForMatch;
        regexResult.range = match.range;
        regexResult.type = ZHRegexResultTypeEmail;
        [regexResults addObject:regexResult];
    }];
    return regexResults;
}
- (NSArray *)regexResultsWithText:(NSString *)text
{
    //用来存放所有的匹配结果
    NSMutableArray *regexResults = [NSMutableArray arrayWithCapacity:5];
    //匹配表情
    NSArray *emotionArray = [self regexResultEmotion:text];
    [regexResults addObjectsFromArray:emotionArray];
    
    //匹配链接
    NSArray *urlArray = [self regexResultUrl:text];
    [regexResults addObjectsFromArray:urlArray];

    //匹配电话号码
    NSArray *phoneArray = [self regexResultPhoneNumber:text];
    [regexResults addObjectsFromArray:phoneArray];
    
    //匹配邮箱地址
    NSArray *emailAddressArray = [self regexResultEmail:text];
    [regexResults addObjectsFromArray:emailAddressArray];

    //排序
    [regexResults sortUsingComparator:^NSComparisonResult(ZHRegexResult *rR1, ZHRegexResult *rR2) {
        NSInteger loc1 = rR1.range.location;
        NSInteger loc2 = rR2.range.location;
        return [@(loc1) compare:@(loc2)];
    }];
    
    
    return regexResults;
}
#pragma mark - 对外方法
- (NSAttributedString *)attributedStringWithString:(NSString *)string
{
    //1、匹配字符串,得到匹配结果
    NSArray *regexResults = [self regexResultsWithText:string];
    
    //2、根据匹配结果，拼接对应的图片表情和普通文本
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = NSMakeRange(0, attributedText.length);
    [attributedText addAttribute:NSForegroundColorAttributeName value:self.defaultColor range:range];
    [attributedText addAttribute:NSFontAttributeName value:self.font range:range];
    
    [regexResults enumerateObjectsUsingBlock:^(ZHRegexResult *result, NSUInteger idx, BOOL *stop) {
        
        switch (result.type) {
            case ZHRegexResultTypeEmotion:
            {
                if ([ZHEmotionTool emotionWithDesc:result.string]) {
                    [attributedText addAttribute:ZHRichEmotion value:result range:result.range];
                }
            }
                break;
            case ZHRegexResultTypeURL:
            {
                [attributedText addAttribute:NSForegroundColorAttributeName value:self.defaultLinkColor range:result.range];
                [attributedText addAttribute:ZHRichLinkUrl value:result range:result.range];
                [attributedText addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:result.range];
            }
                break;
            case ZHRegexResultTypePhoneNumber:
            {
                [attributedText addAttribute:NSForegroundColorAttributeName value:self.defaultLinkColor range:result.range];
                [attributedText addAttribute:ZHRichPhoneNumber value:result range:result.range];
            }
            case ZHRegexResultTypeEmail:
            {
                [attributedText addAttribute:NSForegroundColorAttributeName value:self.defaultLinkColor range:result.range];
                [attributedText addAttribute:ZHRichEmailAddress value:result range:result.range];
            }
                break;
            default:
                
                break;
        }
        
    }];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedText enumerateAttributesInRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        if (attrs[ZHRichEmotion])
        {
            ZHTextAttachment *attachment = [[ZHTextAttachment alloc] init];
            ZHRegexResult *result = attrs[ZHRichEmotion];
            NSString *desc = result.string;
            attachment.emotion = [ZHEmotionTool emotionWithDesc:desc];
            attachment.bounds = CGRectMake(0, self.font.descender, self.font.lineHeight, self.font.lineHeight);
            //将附件包装成富文本
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attachment];
            [attributedString appendAttributedString:attachString];
        }else{
            NSAttributedString *attachString = [attributedText attributedSubstringFromRange:range];
            [attributedString appendAttributedString:attachString];
        }
    }];
    
    return attributedString;
}

- (NSString *)stringWithAttributedString:(NSAttributedString *)attributedString
{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    NSRange range = NSMakeRange(0, attributedString.length);
    [attributedString enumerateAttributesInRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        if (attrs[@"NSAttachment"]) {
            ZHTextAttachment *attachment = attrs[@"NSAttachment"];
            if ([attachment isKindOfClass:[ZHTextAttachment class]]) {
                [string appendString:attachment.emotion.chs];
            }
        }else{
            NSAttributedString *subAttributedString = [attributedString attributedSubstringFromRange:range];
            [string appendString:subAttributedString.string];
            
        }
    }];
    
    return string;
}
@end
