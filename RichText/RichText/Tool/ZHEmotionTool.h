//
//  ZHEmotionTool.h
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZHEmotion;

@interface ZHEmotionTool : NSObject
@property(class, nonatomic, readonly) ZHEmotionTool *sharedEmotionTool;
@property (nonatomic,strong) NSArray *defaultEmotions;

/**
 根据表情的文字描述找出对应的表情对象

 @param desc 表情的文字描述
 @return 表情对象
 */
+ (ZHEmotion *)emotionWithDesc:(NSString *)desc;
+ (UIImage *)animatedGIFWithName:(NSString *)name;
@end


