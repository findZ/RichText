//
//  ZHTextAttachment.h
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZHEmotion;

@interface ZHTextAttachment : NSTextAttachment
@property (nonatomic, strong) ZHEmotion *emotion;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic,strong) UIImage *gifImage;
@property (nonatomic,assign) CGRect imageBounds;
@property (nonatomic,assign) CGFloat height;
@end

NS_ASSUME_NONNULL_END
