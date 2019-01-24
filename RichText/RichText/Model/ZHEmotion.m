//
//  ZHEmotion.m
//  RichText
//
//  Created by wzh on 2019/1/23.
//  Copyright © 2019 ZH. All rights reserved.
//

#import "ZHEmotion.h"

@implementation ZHEmotion
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.chs, self.png];
}
//防止崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/**
 *  当存储一个文件数据的时候会调用该方法
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.chs forKey:@"chs"];
    [encoder encodeObject:self.cht forKey:@"cht"];
    [encoder encodeObject:self.gif forKey:@"gif"];
    [encoder encodeObject:self.png forKey:@"png"];
    [encoder encodeObject:self.directory forKey:@"directory"];
}
/**
 *  当从一个文件中读取数据的时候会调用该方法
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    
    if (self = [super init]) {
        self.chs = [decoder decodeObjectForKey:@"chs"];
        self.cht = [decoder decodeObjectForKey:@"cht"];
        self.gif = [decoder decodeObjectForKey:@"gif"];
        self.png = [decoder decodeObjectForKey:@"png"];
        self.directory = [decoder decodeObjectForKey:@"directory"];
        
    }
    return self;
}
@end
