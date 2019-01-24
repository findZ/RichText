//
//  ZHEmotion.h
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHEmotion : NSObject
/**表情的简体文字描述*/
@property (nonatomic,copy) NSString *chs;

/**表情的繁体文字描述*/
@property (nonatomic,copy) NSString *cht;

/**表情的png名称*/
@property (nonatomic,copy) NSString *png;

/**表情的gif名称*/
@property (nonatomic,copy) NSString *gif;

/**表情存放的路径*/
@property (nonatomic,copy) NSString *directory;
@end

NS_ASSUME_NONNULL_END
