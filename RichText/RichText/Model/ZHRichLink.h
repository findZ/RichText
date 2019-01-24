//
//  ZHRichLink.h
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, ZHRichLinkType) {
    ZHRichLinkTypeURL = 0,
    ZHRichLinkTypeEmail,
    ZHRichLinkTypePhoneNumber,
    ZHRichLinkTypeAt,
    ZHRichLinkTypePoundSign,
};

@interface ZHRichLink : NSObject
/**链接文字*/
@property (nonatomic,copy) NSString *text;
/**链接范围*/
@property (nonatomic, assign) NSRange range;
/**链接的边框*/
@property (nonatomic,strong) NSArray *rects;
/**链接类型*/
@property (nonatomic, assign) ZHRichLinkType type;
/**选中的颜色*/
@property (nonatomic, strong) UIColor *selectedColor;
@end

