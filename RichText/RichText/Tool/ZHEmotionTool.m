//
//  ZHEmotionTool.m
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import "ZHEmotionTool.h"
#import "ZHEmotion.h"
#import <ImageIO/ImageIO.h>

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
            emotion.image = [UIImage imageNamed:emotion.directory];
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

+ (UIImage *)animatedGIFWithName:(NSString *)name;
{
    //1.加载Gif图片，转换成Data类型
    NSString *str = [NSString stringWithFormat:@"%@@2x",name];
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:ZHBundleName(str) ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        return nil;
    }
    UIImage *animatedImage;
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:5];
    CGFloat duration = 0.0;
    
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (src) {
        //获取gif的帧数
        NSUInteger frameCount = CGImageSourceGetCount(src);
        for (NSInteger i = 0; i < frameCount; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, (size_t) i, NULL);
            //把CGImage转化为UIImage
            UIImage *frameImage = [UIImage imageWithCGImage:img];
            [imageArray addObject:frameImage];
            
            CFDictionaryRef dictRef = CGImageSourceCopyPropertiesAtIndex(src, i, NULL);
            NSDictionary *dict = (__bridge NSDictionary *)dictRef;
            NSDictionary *gifDict = dict[(NSString *)kCGImagePropertyGIFDictionary];
            CGFloat delayTime = [[gifDict objectForKey:(NSString *)kCGImagePropertyGIFDelayTime] floatValue];
            duration += delayTime;
            CGImageRelease(img);
        }
    }
    CFRelease(src);
    animatedImage = [UIImage animatedImageWithImages:imageArray duration:duration];
    return animatedImage;

}

@end
