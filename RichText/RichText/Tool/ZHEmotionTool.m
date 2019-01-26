//
//  ZHEmotionTool.m
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import "ZHEmotionTool.h"
#import "ZHEmotion.h"

#define  ZHBundleName(name) [NSString stringWithFormat:@"ZHEmotions.bundle/%@",name]

static ZHEmotionTool *_emotionTool;

@implementation ZHEmotionTool
+ (ZHEmotionTool *)sharedEmotionTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emotionTool = [[self alloc] init];
    });
    return _emotionTool;
}

#pragma mark - 懒加载
- (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        
        NSString *plist = [[NSBundle bundleForClass:self.class] pathForResource:ZHBundleName(@"ZHEmotions") ofType:@"plist"];
        NSArray *souresArray = [NSArray arrayWithContentsOfFile:plist];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
        for (NSDictionary *dict in souresArray) {
            ZHEmotion *emotion = [[ZHEmotion alloc] init];
            [emotion setValuesForKeysWithDictionary:dict];
            emotion.directory = ZHBundleName(emotion.png);
            [array addObject:emotion];
        }
        _defaultEmotions = array;
    }
    return _defaultEmotions;
}

/**
 *  根据表情的文字描述找出对应的表情对象
 */
+ (ZHEmotion *)emotionWithDesc:(NSString *)desc
{
    if (!desc) return  nil;
    
    __block ZHEmotion *foundEmotion = nil;
    
    //从默认表情中查找
    [[self sharedEmotionTool].defaultEmotions enumerateObjectsUsingBlock:^(ZHEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]) {
            foundEmotion = emotion;
            //停止遍历
            *stop = YES;
        }
    }];
    
    return foundEmotion;
    
}
@end
