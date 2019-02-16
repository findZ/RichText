//
//  ZHTextAttachment.m
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import "ZHTextAttachment.h"
#import "ZHEmotion.h"
#import "ZHEmotionTool.h"

@implementation ZHTextAttachment
- (void)setEmotion:(ZHEmotion *)emotion
{
    _emotion = emotion;
    self.image = emotion.image;
    self.gifImage = emotion.gifImage;
}
- (nullable UIImage *)imageForBounds:(CGRect)imageBounds textContainer:(nullable NSTextContainer *)textContainer characterIndex:(NSUInteger)charIndex
{
    self.imageBounds = imageBounds;
    UIView *view = [textContainer valueForKey:@"_textView"];
    if (view.tag == 1090) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZHTextAttachmentImageDone" object:nil userInfo:@{@"ZHTextAttachment":self}];
    }
    return self.image;
}
@end
