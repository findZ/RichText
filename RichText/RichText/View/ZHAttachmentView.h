//
//  ZHAttachmentView.h
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHAttachmentView : UIImageView
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, copy) NSString *urlString;
- (void)addTarget:(nullable id)target action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
