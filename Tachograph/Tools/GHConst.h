//
//  GHConst.h
//  歌本哈根
//
//  Created by Mac on 13-10-31.
//  Copyright (c) 2013年 Ethan.personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSDictionary+NullSafe.h"

#define kNewRedColor kColor(238, 80, 80)
#define kNewGrayColor kColor(221, 221, 221)
#define kSelf(name)    __weak typeof(self) (name) = self;
#define BEGIN {
#define END }

#ifdef DEBUG
#define kLogFL(fmt, ...) NSLog((@"%s," "[lineNum:%d]" fmt) , __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define kLogL(fmt, ...)  NSLog((@"===[lineNum:%d]" fmt), __LINE__, ##__VA_ARGS__);
#define kLogC(fmt, ...)  NSLog((fmt), ##__VA_ARGS__);
#else
#define kLogFL(fmt, ...);
#define kLogL(fmt, ...);
#define kLogC(fmt, ...);
#endif

#pragma mark 打印计算
#define kPRINT_INT(n) printf(#n " = %d\n",n)

#pragma mark - ------------宏-------------

#pragma mark屏幕宽高
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH [UIScreen mainScreen].bounds.size.height

#pragma mark 6p  1像素线宽适配
#define kLine  1.0f/([UIScreen mainScreen].scale)

#pragma mark 随机色
#define kArcColor kColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#pragma mark 自定义颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#pragma mark 空字符串安全判断
#define kSAFESTR(str) str==nil?@"":str

#pragma mark 屏幕尺寸
#define kScreenFrame [[UIScreen mainScreen] applicationFrame]
#define kScreenBounds [[UIScreen mainScreen] bounds]

// scrollView iOS7 iOS8适配 -64  a iOS7以下  b iOS7   c iOS8
#define kScrollView(a,b,c)  (kiOS7Later? (kiOS8Later? c : b):a)
#pragma mark 系统版本
#define kiOS7Later ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define kiOS8Later ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define kScreeniPhone5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark lable的对齐方式
#ifdef NSTextAlignmentCenter // older versions
#   define kLabelAlignmentCenter    UITextAlignmentCenter
#   define kLabelAlignmentLeft      UITextAlignmentLeft
#   define kLabelAlignmentRight     UITextAlignmentRight
#   define kLabelTruncationTail     UILineBreakModeTailTruncation
#   define kLabelTruncationMiddle   UILineBreakModeMiddleTruncation
#else // iOS6 and later
#   define kLabelAlignmentCenter    NSTextAlignmentCenter
#   define kLabelAlignmentLeft      NSTextAlignmentLeft
#   define kLabelAlignmentRight     NSTextAlignmentRight
#   define kLabelTruncationTail     NSLineBreakByTruncatingTail
#   define kLabelTruncationMiddle   NSLineBreakByTruncatingMiddle
#endif

#pragma mark - -------------------------

#pragma mark - ----------extern const NSString *---------------

extern const NSString *GHScrollViewPanKeyNotification;
extern const CGFloat GHMargin;


#pragma mark -

@interface GHConst : NSObject
#pragma mark - ------------创建-------------
#pragma mark 创建目录文件夹
+ (NSString *)CreateList:(NSString *)List ListName:(NSString *)Name;

#pragma mark - ------------获取-------------
#pragma mark 获取设备系统版本
+ (CGFloat)getCurrentDevice;

#pragma mark 获取程序的Home目录路径
+ (NSString *)GetHomeDirectoryPath;

#pragma mark 获取document目录路径
+ (NSString *)getDocumentDirectoryPath;

#pragma mark 获取Cache目录路径
+ (NSString *)GetCachePath;

#pragma mark 获取Library目录路径
+ (NSString *)GetLibraryPath;

#pragma mark 获取Tmp目录路径
+ (NSString *)GetTmpPath;

#pragma mark 获取文件路径
+ (NSString*)GetPathForCaches:(NSString *)filename;
+ (NSString*)GetPathForCaches:(NSString *)filename inDir:(NSString*)dir;

+ (NSString*)GetPathForDocuments:(NSString*)filename;
+ (NSString*)GetPathForDocuments:(NSString *)filename inDir:(NSString*)dir;

+ (NSString*)GetPathForResource:(NSString *)name;
+ (NSString*)GetPathForResource:(NSString *)name inDir:(NSString*)dir;

#pragma mark 获取目录列表里所有的文件名
+ (NSArray *)GetSubpathsAtPath:(NSString *)path;

#pragma mark -  ------------查找路径-----------

#pragma mark -  ------------删除-------------
#pragma mark 删除指定文件
+ (void)DeleteFile:(NSString*)filepath;

#pragma mark 删除 document/dir 目录下 所有文件
+ (void)deleteAllForDocumentsDir:(NSString*)dir;

#pragma mark 根据文件名 删除文件
+ (BOOL)deleteWithFilePath:(NSString *)fileName;

#pragma mark 根据文件名 删除document下的某一个文件下的 文件
+ (BOOL)deleteWithFileWithDocumentPath:(NSString *)fileName dirName:(NSString *)dirStr;

#pragma mark -  ------------写入-------------
#pragma mark 写入NsArray文件
+ (BOOL)WriteFileArray:(NSArray *)ArrarObject SpecifiedFile:(NSString *)path;

#pragma mark 写入NSDictionary文件
+ (BOOL)WriteFileDictionary:(NSMutableDictionary *)DictionaryObject SpecifiedFile:(NSString *)path;

#pragma mark 根据名称 归档对象
+ (BOOL)archiverWithFileName:(NSString*)fileName Object:(id)obj;

#pragma mark -  ------------读取-------------
#pragma mark 直接取文件数据
+ (NSData*)GetDataForResource:(NSString*)name inDir:(NSString*) type;
+ (NSData*)GetDataForDocuments:(NSString *)name inDir:(NSString*)dir;
+ (NSData*)GetDataForPath:(NSString*)path;

#pragma mark 根据名称解档对象
+ (id)archiverWithFileName:(NSString*)fileName;

#pragma mark 根据数字获取中文
+(NSString*)getCharacterWithNumber:(NSInteger)number;

#pragma mark - ------------判断-------------
#pragma mark 是否存在该文件
+ (BOOL)IsFileExists:(NSString *)filepath;

#pragma mark 正则判断字符串中是否都是汉字
+ (BOOL)predicateAllChinese:(NSString *)textStr;

#pragma mark 验证手机号码合法性（正则）
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber;

+ (BOOL)isEmptyString:(NSString *)str;


+ (CGSize)sizeWithFont:(UIFont *)font textStr:(NSString *)textStr;

/***********************DateUtils********************/
+ (BOOL)isLeapYear:(NSInteger)year;
/*
 * @abstract caculate number of days by specified month and current year
 * @paras year range between 1 and 12
 */
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month;
/*
 * @abstract caculate number of days by specified month and year
 * @paras year range between 1 and 12
 */
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger) year;

+ (NSInteger)getCurrentYear;

+ (NSInteger)getCurrentMonth;

+ (NSInteger)getCurrentDay;

+ (NSInteger)getMonthWithDate:(NSDate*)date;

+ (NSInteger)getDayWithDate:(NSDate*)date;

+ (NSString*)dateSinceNowWithInterval:(NSInteger)dayInterval;

+ (NSDate*)dateSinceCurrentDayWithInterval:(NSInteger)dayInterval;

/********************** System Utils ***********************/
//弹出UIAlertView
+ (void)showAlertMessage:(NSString *)msg;
//关闭键盘
+ (void)closeKeyboard;
//获取MD5加密后字符串
+ (NSString *)md5FromString:(NSString *)str;

/******* UITableView & UINavigationController Utils *******/
//返回View覆盖多余的tableview cell线条
+ (UIView *)tableViewsFooterView;
//返回UILabel作为UITableView的header
+ (UILabel *)tableViewsHeaderLabelWithMessage:(NSString *)message;
//获取没有文字的导航栏返回按钮
+ (UIBarButtonItem *)navigationBackButtonWithNoTitle;

/********************* SVProgressHUD **********************/
//弹出操作错误信息提示框
+ (void)showErrorMessage:(NSString *)message;
//弹出操作成功信息提示框
+ (void)showSuccessMessage:(NSString *)message;
//弹出加载提示框
+ (void)showProgressMessage:(NSString *) message;
//取消弹出框
+ (void)dismissHUD;

/********************** NSDate Utils ***********************/

//根据指定格式将NSDate转换为NSString
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter;
//根据指定格式将NSString转换为NSDate
+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter;

/********************* Category Utils **********************/
//根据颜色码取得颜色对象
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

/********************* Verification Utils **********************/


/**
 *  根据最大的值 返回文字数组
 */
+(NSArray*)getCharacterNumberArrayWithMaxNumber:(NSInteger)maxNumber;

/**
 *  获取值
 */
+(NSArray*)getCharacterNumberArrayWithMaxNumber:(NSInteger)maxNumber prefix:(NSString *)prefix subfix:(NSString *)subfix;
@end


