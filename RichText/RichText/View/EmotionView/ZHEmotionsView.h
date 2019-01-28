//
//  ZHEmotionsView.h
//  RichText
//
//  Created by wzh on 2019/1/25.
//  Copyright © 2019 ZH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHEmotion;

@protocol ZHEmotionsViewDelegate <NSObject>

- (void)didSelectedEmotion:(ZHEmotion *)emotion;
- (void)didSelectSendButton:(UIButton *)sendButton;
@end

@interface ZHEmotionsView : UIView
@property (nonatomic, weak) id<ZHEmotionsViewDelegate> delegate;
- (void)reloadData;
@end

