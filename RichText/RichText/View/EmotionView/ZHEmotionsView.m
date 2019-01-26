//
//  ZHEmotionsView.m
//  RichText
//
//  Created by wzh on 2019/1/25.
//  Copyright © 2019 ZH. All rights reserved.
//

#import "ZHEmotionsView.h"
#import "ZHFaceCell.h"
#import "ZHEmotionTool.h"
#import "ZHEmotion.h"

#define K_FaceViewHeight  216
#define K_FaceViewWidth   [UIScreen mainScreen].bounds.size.width
#define K_SendButtonHeight 60

@interface ZHEmotionsView ()<UIInputViewAudioFeedback,UICollectionViewDataSource, UICollectionViewDelegate, ZHFaceCellDelegate>
@property (nonatomic, weak) UICollectionView *faceView;
@property (nonatomic, weak) UIButton *sendButton;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic, weak) UIButton *preview;
@property (nonatomic,assign) CGPoint startPoint;
@end

@implementation ZHEmotionsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
        self.dataArray = [ZHEmotionTool sharedEmotionTool].defaultEmotions;

        [self setupSubView];
    }
    return self;
}
- (void)setupSubView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (K_FaceViewWidth - 20)/8;
    CGFloat height = K_FaceViewHeight/4;
    flowLayout.itemSize = CGSizeMake(width, height);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    UICollectionView *faceView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, K_FaceViewWidth, K_FaceViewHeight) collectionViewLayout:flowLayout];
    [faceView registerClass:[ZHFaceCell class] forCellWithReuseIdentifier:@"ZHFaceCell"];
    faceView.backgroundColor = [UIColor whiteColor];
    faceView.showsHorizontalScrollIndicator = NO;
    faceView.dataSource = self;
    faceView.delegate = self;
    [self addSubview:faceView];
    self.faceView = faceView;
    
    
    UILongPressGestureRecognizer *longPR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFace:)];
    longPR.minimumPressDuration = 0.5;
    [faceView addGestureRecognizer:longPR];
    
    
    CGFloat btnH = self.bounds.size.height - K_FaceViewHeight;
    CGFloat btnY = K_FaceViewHeight;
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(K_FaceViewWidth - K_SendButtonHeight, btnY, K_SendButtonHeight, btnH)];
    sendButton.backgroundColor = [UIColor orangeColor];
    [sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self addSubview:sendButton];
    self.sendButton = sendButton;
    
    UIButton *preview = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
    preview.hidden = YES;
//    preview.backgroundColor = [UIColor redColor];
    [self addSubview:preview];
    self.preview = preview;
    
}
- (void)sendButtonClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(didSelectSendButton:)]) {
        [self.delegate didSelectSendButton:btn];
        btn.enabled = NO;
    }
}
#pragma mark - UIInputViewAudioFeedback  实现点击音效
- (BOOL)enableInputClicksWhenVisible
{
    return YES;
}

- (void)longPressFace:(UILongPressGestureRecognizer *)longPress
{
    CGPoint point = [longPress locationInView:longPress.view];
    CGPoint center = CGPointMake(point.x, point.y - 40);
    
    for (UIView *subView in longPress.view.subviews) {//查找
        if ([subView isKindOfClass:[ZHFaceCell class]]) {
            if (CGRectContainsPoint(subView.frame, point)) {
                ZHFaceCell *cell = (ZHFaceCell *)subView;
                [self.preview setImage:cell.image forState:UIControlStateNormal];
            }
        }
    }
    
    if (CGRectContainsPoint(self.faceView.frame, point)) {
        self.preview.center = center;
    }
    
//    NSLog(@"%@",NSStringFromCGPoint(point));
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            self.preview.hidden = NO;
            self.startPoint = center;
            break;
        case UIGestureRecognizerStateEnded:
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.preview.center = self.startPoint;
            } completion:^(BOOL finished) {
                self.preview.hidden = YES;
            }];
            
        }
            break;
        default:
            break;
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZHFaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZHFaceCell" forIndexPath:indexPath];
    cell.emotion = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - ZHFaceCellDelegate
- (void)didSelectedFaceButton:(UIButton *)faceBtn emotion:(ZHEmotion *)emotion
{
    [[UIDevice currentDevice] playInputClick];
    if ([self.delegate respondsToSelector:@selector(didSelectedEmotion:)]) {
        [self.delegate didSelectedEmotion:emotion.chs];
        self.sendButton.enabled = YES;
    }
}
@end
