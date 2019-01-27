//
//  ZHFacePreview.h
//  RichText
//
//  Created by wangzhaohui-Mac on 2019/1/27.
//  Copyright © 2019 ZH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZHEmotion;

@interface ZHFacePreview : UIView
@property (nonatomic,strong) ZHEmotion *emotion;
@property (nonatomic, weak) UIImageView *imageView;
@end

NS_ASSUME_NONNULL_END
