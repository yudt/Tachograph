//
//  NSDictionary+NullSafe.h
//  Yida
//
//  Created by 王强 on 15/8/6.
//  Copyright (c) 2015年 diandiandongli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullSafe)

- (NSString *)valueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

@end
