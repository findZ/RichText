//
//  ZHFacePreview.m
//  RichText
//
//  Created by wangzhaohui-Mac on 2019/1/27.
//  Copyright © 2019 ZH. All rights reserved.
//

#import "ZHFacePreview.h"
#import "ZHEmotion.h"
#import "ZHEmotionTool.h"

@implementation ZHFacePreview

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = UIColor.orangeColor.CGColor;
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    self.imageView = imageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/2);

}

- (void)setEmotion:(ZHEmotion *)emotion
{
    _emotion = emotion;
    UIImage *image = [ZHEmotionTool animatedGIFWithName:emotion.gif];
    self.imageView.image = image;
}
@end
