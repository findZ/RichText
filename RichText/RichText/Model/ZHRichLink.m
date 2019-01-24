//
//  ZHRichLink.m
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import "ZHRichLink.h"

@implementation ZHRichLink
- (UIColor *)selectedColor
{
    if (!_selectedColor) {
        _selectedColor = [UIColor lightGrayColor];
    }
    return _selectedColor;
}
@end
