//
//  ZHFaceCell.m
//  RichText
//
//  Created by wangzhaohui-Mac on 2019/1/26.
//  Copyright © 2019 ZH. All rights reserved.
//

#import "ZHFaceCell.h"
#import "ZHEmotion.h"
#import "ZHFacePreview.h"

#define K_MAX_Row 3      //最大行
#define K_MAX_Column 7   //最大列


#define K_Screen_Width  [UIScreen mainScreen].bounds.size.width

@interface ZHFaceCell ()
@property (nonatomic, strong) ZHFacePreview *preview;
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
    CGFloat spacing = 10;
    CGFloat btnWidth = (K_Screen_Width - (K_MAX_Column + 1) * spacing)/K_MAX_Column;
    CGFloat btnHeight = (self.bounds.size.height - (K_MAX_Row) * spacing)/K_MAX_Row;
    NSInteger count = K_MAX_Column*K_MAX_Row;
    for (NSInteger i = 0; i < count; i++) {
        
        CGFloat row = i / K_MAX_Column;
        CGFloat col = i % K_MAX_Column;
        CGFloat y = row * (btnHeight + spacing) + spacing;
        CGFloat x = col * (btnWidth + spacing) + spacing;
        UIButton *faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, btnWidth, btnHeight)];
        faceBtn.hidden = YES;
        faceBtn.tag = i;
//        faceBtn.backgroundColor = [UIColor redColor];
//        [faceBtn setTitle:[NSString stringWithFormat:@"%ld",(long)i] forState:UIControlStateNormal];
         [faceBtn addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [faceBtn addTarget:self action:@selector(longPressButton:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:faceBtn];
    }
    UILongPressGestureRecognizer *longPR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFace:)];
    longPR.minimumPressDuration = 0.5;
    [self.contentView addGestureRecognizer:longPR];
    
    ZHFacePreview *preview = [[ZHFacePreview alloc] initWithFrame:CGRectMake(0, 0, 40, 80)];
    self.preview = preview;
}
- (void)setFaceArray:(NSArray<ZHEmotion *> *)faceArray
{
    _faceArray = faceArray;
    //默认隐藏没有数据的表情按钮
    [self.contentView.subviews makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
    for (NSInteger i = 0; i < faceArray.count; i++) {
        UIButton *faceBtn = self.contentView.subviews[i];
        if ([faceBtn isKindOfClass:[UIButton class]]) {
            ZHEmotion *emotion = faceArray[i];
            faceBtn.hidden = NO;
            UIImage *image = emotion.image;
            [faceBtn setImage:image forState:UIControlStateNormal];
            [faceBtn setImage:image forState:UIControlStateHighlighted];
        }
    }
    
}
- (void)faceBtnClick:(UIButton *)btn
{
//    NSLog(@"%ld",btn.tag);
    ZHEmotion *emotion = self.faceArray[btn.tag];
    if ([self.delegate respondsToSelector:@selector(didSelectedFaceButton:emotion:)]) {
        [self.delegate didSelectedFaceButton:btn emotion:emotion];
    }
}
- (void)longPressButton:(UIButton *)btn
{
    ZHEmotion *emotion = self.faceArray[btn.tag];
    if (emotion.type == ZHEmotionTypeDelete) {
        if ([self.delegate respondsToSelector:@selector(longPressDeleteButton:)]) {
            [self.delegate longPressDeleteButton:btn];
        }
    }
}
- (void)longPressFace:(UILongPressGestureRecognizer *)longPress
{
    CGPoint point = [longPress locationInView:longPress.view];
    CGPoint center = CGPointMake(point.x, point.y-40);
    
    if (CGRectContainsPoint(longPress.view.frame, point)) {
        self.preview.center = center;
        for (UIView *subView in longPress.view.subviews) {//查找
            if ([subView isKindOfClass:[UIButton class]]) {
                if (CGRectContainsPoint(subView.frame, point)) {
                    ZHEmotion *emotion = self.faceArray[subView.tag];
                    if (emotion.type == ZHEmotionTypeFace) {
                        [self showPreview:YES];
                        self.preview.emotion = emotion;
                    }else{
                        [self showPreview:NO];
                    }
                }
            }
        }
    }else{
        [self showPreview:NO];
    }

    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateEnded:
        {
            [UIView animateWithDuration:0.25 animations:^{
            } completion:^(BOOL finished) {
                [self showPreview:NO];
            }];
            
        }
            break;
        default:
            break;
    }
}
- (void)showPreview:(BOOL)isShow
{
    [self.preview removeFromSuperview];
    if (isShow) {
        [self.superview.superview addSubview:self.preview];
    }
}
@end
