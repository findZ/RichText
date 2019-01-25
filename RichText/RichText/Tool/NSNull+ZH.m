//
//  NSNull+ZH.m
//  RichText
//
//  Created by wzh on 2019/1/25.
//  Copyright © 2019 ZH. All rights reserved.
//

#import "NSNull+ZH.h"

@implementation NSNull (ZH)
#define pLog
#define JsonObjects @[[NSMutableString string],@0,[NSMutableDictionary dictionary],[NSMutableArray array],[NSMutableSet set]]
- (id)forwardingTargetForSelector:(SEL)aSelector {
    for (id jsonObj in JsonObjects) {
        if ([jsonObj respondsToSelector:aSelector]) {
#ifdef pLog
            NSLog(@"NULL出现啦！这个对象应该是是_%@",[jsonObj class]);
#endif
            return jsonObj;
        }
    }
    return [super forwardingTargetForSelector:aSelector];
}
@end
