//
//  NSDictionary+NullSafe.m
//  Yida
//
//  Created by 王强 on 15/8/6.
//  Copyright (c) 2015年 diandiandongli. All rights reserved.
//

#import "NSDictionary+NullSafe.h"
#import "GHConst.h"

@implementation NSDictionary (NullSafe)

- (NSString *)valueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    id result = [self valueForKey:key];
    if ([GHConst isEmptyString:key])
    {
        return defaultValue;
    }
    
    if ([result isKindOfClass:[NSString class]]) {
        return (NSString *)result;
    } else {
        return [result stringValue];
    }
}

@end
