//
//  UIImage+BundleImage.h
//  SuperPaper
//
//  Created by admin on 16/1/14.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BundleImage)


+ (nullable UIImage *)imageWithASName:(nullable NSString *)nameStr directory:(nullable NSString *)dirStr;

+ (nullable UIImage *)imageWithASName:(nullable NSString *)nameStr directory:(nullable NSString *)dirStr bundle:(nullable NSString *)bundleName;

+ (nullable UIImage *)imageWithASName:(nullable NSString *)nameStr directory:(nullable NSString *)dirStr type:(nullable NSString *)typeStr;

@end
