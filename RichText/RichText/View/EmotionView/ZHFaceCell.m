//
//  ZHFaceCell.m
//  RichText
//
//  Created by wangzhaohui-Mac on 2019/1/26.
//  Copyright © 2019 ZH. All rights reserved.
//

#import "ZHFaceCell.h"
#import "ZHEmotion.h"


@interface ZHFaceCell ()
@property (nonatomic, weak) UIButton *faceBtn;
@end
@implementation ZHFaceCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor purpleColor];
        [self setupView];
    }
    return self;
}
- (void)setupView
{
    UIButton *faceBtn = [[UIButton alloc] initWithFrame:self.bounds];
//    faceBtn.backgroundColor = [UIColor redColor];
    [faceBtn addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:faceBtn];
    self.faceBtn = faceBtn;
}

- (void)setEmotion:(ZHEmotion *)emotion
{
    _emotion = emotion;
    [self.faceBtn setImage:[UIImage imageNamed:emotion.directory] forState:UIControlStateNormal];
    [self.faceBtn setImage:[UIImage imageNamed:emotion.directory] forState:UIControlStateHighlighted];
    self.image = self.faceBtn.currentImage;
}
- (void)faceBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(didSelectedFaceButton:emotion:)]) {
        [self.delegate didSelectedFaceButton:btn emotion:self.emotion];
    }
}
@end
