//
//  ZHTextAttachment.m
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import "ZHTextAttachment.h"
#import "ZHEmotion.h"

@implementation ZHTextAttachment
- (void)setEmotion:(ZHEmotion *)emotion
{
    _emotion = emotion;
    if (emotion.directory) {
        self.image = [UIImage imageNamed:emotion.directory];
    }
}
@end
