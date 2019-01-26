//
//  ZHRichView.h
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZHAttachmentView;

@protocol ZHRichViewDelegate <NSObject>

@optional
///图文混排中图片点击回调
- (void)didClickImageWithView:(ZHAttachmentView *)view;
///网址链接点击回调
- (void)didClickLinkWithUrlString:(NSString *)urlString;
///邮箱地址点击回调
- (void)didClickLinkWithEmailString:(NSString *)emailAddress;
///电话号码点击回调
- (void)didClickLinkWithPhoneNumberString:(NSString *)phoneNumber;

@end


@interface ZHRichView : UIView
@property (nonatomic, weak) id<ZHRichViewDelegate> delegate;
@property (nonatomic, copy) NSAttributedString *attributedText;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong, readonly) NSArray *links;
@property (nonatomic, strong, readonly) NSArray *attachments;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@end

NS_ASSUME_NONNULL_END
