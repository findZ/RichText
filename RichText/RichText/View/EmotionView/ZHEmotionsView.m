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
#import "ZHFacePreview.h"
#import "UIColor+ZHColor.h"

#define K_FaceViewHeight  216
#define K_FaceViewWidth   [UIScreen mainScreen].bounds.size.width
#define K_SendButtonHeight 60
#define K_PageControlHeight 44

@interface ZHEmotionsView ()<UIInputViewAudioFeedback,UICollectionViewDataSource, UICollectionViewDelegate, ZHFaceCellDelegate>
@property (nonatomic, weak) UICollectionView *faceView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation ZHEmotionsView
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightTextColor];
        [self setupSubView];
        [self loadData];
    }
    return self;
}
- (void)setupSubView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(K_FaceViewWidth, K_FaceViewHeight - K_PageControlHeight);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *faceView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, K_FaceViewWidth, K_FaceViewHeight - K_PageControlHeight) collectionViewLayout:flowLayout];
    [faceView registerClass:[ZHFaceCell class] forCellWithReuseIdentifier:@"ZHFaceCell"];
    faceView.backgroundColor = [UIColor whiteColor];
    faceView.showsHorizontalScrollIndicator = NO;
    faceView.pagingEnabled = YES;
    faceView.dataSource = self;
    faceView.delegate = self;
    [self addSubview:faceView];
    self.faceView = faceView;
    
    
    CGFloat btnH = self.bounds.size.height - K_FaceViewHeight;
    CGFloat btnY = K_FaceViewHeight;
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(K_FaceViewWidth - K_SendButtonHeight, btnY, K_SendButtonHeight, btnH)];
    sendButton.backgroundColor = [UIColor ZHColorWithRed:46 green:123 blue:246];
    [sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

    [self addSubview:sendButton];
    self.sendButton = sendButton;
    

    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(faceView.frame), K_FaceViewWidth, K_PageControlHeight)];
    pageControl.backgroundColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.userInteractionEnabled = NO;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
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


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZHFaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZHFaceCell" forIndexPath:indexPath];
    cell.faceArray = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 得到每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int index = fabs(scrollView.contentOffset.x)/pageWidth;
    self.pageControl.currentPage = index;
}
#pragma mark - ZHFaceCellDelegate
- (void)didSelectedFaceButton:(UIButton *)faceBtn emotion:(ZHEmotion *)emotion
{
    [[UIDevice currentDevice] playInputClick];
    if ([self.delegate respondsToSelector:@selector(didSelectedEmotion:)]) {
        [self.delegate didSelectedEmotion:emotion];
        self.sendButton.enabled = YES;
    }
}
- (void)loadData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *array = [ZHEmotionTool sharedEmotionTool].defaultEmotions;
        NSMutableArray *totalArray = [NSMutableArray arrayWithArray:array];
        while (totalArray.count) {
            if(totalArray.count > 20){
                NSIndexSet *indexset = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,20)];
                NSArray *tempArray = [totalArray objectsAtIndexes:indexset];
                NSMutableArray *arrayM = [NSMutableArray arrayWithArray:tempArray];
                ZHEmotion *delete = [[ZHEmotion alloc] init];
                delete.type = ZHEmotionTypeDelete;
                [arrayM addObject:delete];
                [self.dataArray addObject:arrayM];
                [totalArray removeObjectsInArray:tempArray];
            }else{
                NSIndexSet *indexset = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,totalArray.count)];
                NSArray *tempArray = [totalArray objectsAtIndexes:indexset];
                NSMutableArray *arrayM = [NSMutableArray arrayWithArray:tempArray];
                ZHEmotion *delete = [[ZHEmotion alloc] init];
                delete.type = ZHEmotionTypeDelete;
                [arrayM addObject:delete];
                [self.dataArray addObject:arrayM];
                [totalArray removeObjectsInArray:tempArray];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSInteger pages = self.dataArray.count;
                    self.pageControl.numberOfPages = pages;
                });
            }
        }
    });
}
- (void)reloadData
{
    [self.faceView reloadData];
}
@end
