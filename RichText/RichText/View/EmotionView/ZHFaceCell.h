//
//  ZHFaceCell.h
//  RichText
//
//  Created by wangzhaohui-Mac on 2019/1/26.
//  Copyright © 2019 ZH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZHEmotion;

@protocol ZHFaceCellDelegate <NSObject>

- (void)didSelectedFaceButton:(UIButton *)faceBtn emotion:(ZHEmotion *)emotion;

@end

@interface ZHFaceCell : UICollectionViewCell
@property (nonatomic, weak) id<ZHFaceCellDelegate> delegate;
@property (nonatomic,strong) ZHEmotion *emotion;
@property (nonatomic,strong) UIImage *image;
@end

NS_ASSUME_NONNULL_END
