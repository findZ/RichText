//
//  ZHRegexResult.h
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSUInteger, ZHRegexResultType) {
    ZHRegexResultTypeNone = 0,
    ZHRegexResultTypeEmotion,
    ZHRegexResultTypeURL,
    ZHRegexResultTypePhoneNumber,
    ZHRegexResultTypeEmail,
};

@interface ZHRegexResult : NSObject
/**匹配到得字符串*/
@property (nonatomic,copy) NSString *string;
/**匹配到得范围*/
@property (nonatomic, assign) NSRange range;
/**匹配的结果是不是表情*/
@property (nonatomic, assign,getter = isEmotion) BOOL emotion;
/**类型*/
@property (nonatomic, assign) ZHRegexResultType type;
@end


