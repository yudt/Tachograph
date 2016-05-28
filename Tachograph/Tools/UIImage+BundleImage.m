//
//  UIImage+BundleImage.m
//  SuperPaper
//
//  Created by admin on 16/1/14.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "UIImage+BundleImage.h"


@implementation UIImage (BundleImage)

+ (nullable UIImage *)imageWithASName:(nullable NSString *)nameStr directory:(nullable NSString *)dirStr
{
    
    
    NSString *bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources"
                                                          ofType:@"bundle"];
    
     return  [UIImage imageNamed:[[NSBundle bundleWithPath:bundleStr] pathForResource:nameStr
                                                                                   ofType:@"png"
                                                                              inDirectory:dirStr]];
    
    
}

+ (nullable UIImage *)imageWithASName:(nullable NSString *)nameStr directory:(nullable NSString *)dirStr bundle:(nullable NSString *)bundleName
{
    NSString *bundleStr = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    
    return [UIImage imageNamed:[[NSBundle bundleWithPath:bundleStr] pathForResource:nameStr ofType:@"png" inDirectory:dirStr]];
}

+ (nullable UIImage *)imageWithASName:(nullable NSString *)nameStr directory:(nullable NSString *)dirStr type:(nullable NSString *)typeStr
{
    
    
    NSString *bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources"
                                                          ofType:@"bundle"];
    
    return  [UIImage imageNamed:[[NSBundle bundleWithPath:bundleStr] pathForResource:nameStr
                                                                              ofType:typeStr
                                                                         inDirectory:dirStr]];
    
    
}

@end
