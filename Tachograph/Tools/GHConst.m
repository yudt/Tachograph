//
//  GHConst.m
//  歌本哈根
//
//  Created by Mac on 13-10-31.
//  Copyright (c) 2013年 Ethan.personal. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "SVProgressHUD.h"
#import "GHConst.h"

#define DEFAULT_VOID_COLOR [UIColor whiteColor]

const NSString *GHScrollViewPanKeyNotification=@"GHScrollViewPanKeyNotification";
const CGFloat GHNavigationBarH=64.0;



@implementation GHConst


/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊获取程序的Home目录路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSString *)GetHomeDirectoryPath
{
    return NSHomeDirectory();
}

/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊获取Cache目录路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSString *)GetCachePath
{
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    return path;
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊获取Library目录路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSString *)GetLibraryPath
{
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    return path;
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊获取Tmp目录路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSString *)GetTmpPath
{
    return NSTemporaryDirectory();
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊返回Documents下的指定文件路径(加创建)
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSString *)GetDirectoryForDocuments:(NSString *)dir
{
    NSError* error;
    NSString* path = [[self getDocumentDirectoryPath] stringByAppendingPathComponent:dir];
    if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
    {
        //NSLog(@"create dir error: %@",error.debugDescription);
    }
    return path;
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊返回Caches下的指定文件路径
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSString *)GetDirectoryForCaches:(NSString *)dir
{
    NSError* error;
    NSString* path = [[self GetCachePath] stringByAppendingPathComponent:dir];
    
    if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
    {
        //NSLog(@"create dir error: %@",error.debugDescription);
    }
    return path;
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊创建目录文件夹
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSString *)CreateList:(NSString *)List ListName:(NSString *)Name
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *FileDirectory=[List stringByAppendingPathComponent:Name];
    if ([self IsFileExists:Name])
    {
        //NSLog(@"exist,%@",Name);
    }
    else
    {
        [fileManager createDirectoryAtPath:FileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return FileDirectory;
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊写入NsArray文件
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(BOOL)WriteFileArray:(NSArray *)ArrarObject SpecifiedFile:(NSString *)path
{
    return [ArrarObject writeToFile:path atomically:YES];
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊写入NSDictionary文件
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(BOOL)WriteFileDictionary:(NSMutableDictionary *)DictionaryObject SpecifiedFile:(NSString *)path
{
    return [DictionaryObject writeToFile:path atomically:YES];
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊是否存在该文件
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(BOOL)IsFileExists:(NSString *)filepath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊删除指定文件
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(void)DeleteFile:(NSString *)filepath
{
    if([[NSFileManager defaultManager]fileExistsAtPath:filepath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
    }
}
/*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 ＊获取目录列表里所有的文件名
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 */
+(NSArray *)GetSubpathsAtPath:(NSString *)path
{
    NSFileManager *fileManage=[NSFileManager defaultManager];
    NSArray *file=[fileManage subpathsAtPath:path];
    return file;
}
+(void)deleteAllForDocumentsDir:(NSString *)dir
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:[self GetDirectoryForDocuments:dir] error:nil];
    for (NSString* filename in fileList) {
        [fileManager removeItemAtPath:[self GetPathForDocuments:filename inDir:dir] error:nil];
    }
}


#pragma mark- 获取文件的数据
+(NSData *)GetDataForPath:(NSString *)path
{
    return [[NSFileManager defaultManager] contentsAtPath:path];
}
+(NSData *)GetDataForResource:(NSString *)name inDir:(NSString *)dir
{
    return [self GetDataForPath:[self GetPathForResource:name inDir:dir]];
}
+(NSData *)GetDataForDocuments:(NSString *)name inDir:(NSString *)dir
{
    return [self GetDataForPath:[self GetPathForDocuments:name inDir:dir]];
}

#pragma mark- 获取文件路径
+(NSString *)GetPathForResource:(NSString *)name
{
    return [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:name];
}
+(NSString *)GetPathForResource:(NSString *)name inDir:(NSString *)dir
{
    return [[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:dir] stringByAppendingPathComponent:name];
}
+ (NSString *)GetPathForDocuments:(NSString *)filename
{
    return [[self getDocumentDirectoryPath] stringByAppendingPathComponent:filename];
}
+(NSString *)GetPathForDocuments:(NSString *)filename inDir:(NSString *)dir
{
    return [[self GetDirectoryForDocuments:dir] stringByAppendingPathComponent:filename];
}
+(NSString *)GetPathForCaches:(NSString *)filename
{
    return [[self GetCachePath] stringByAppendingPathComponent:filename];
}
+(NSString *)GetPathForCaches:(NSString *)filename inDir:(NSString *)dir
{
    return [[self GetDirectoryForCaches:dir] stringByAppendingPathComponent:filename];
}


+ (CGFloat)getCurrentDevice
{
    return [[UIDevice currentDevice].systemVersion doubleValue];
}
// 消除警告 方法不能使用的警告，方法已经过滤，所以不需要警告。
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+ (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW textStr:(NSString *)textStr
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    if ([self getCurrentDevice]>=7.0) {
        return [textStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    } else {
        return [textStr sizeWithFont:font constrainedToSize:maxSize];
    }
}
#pragma clang diagnostic pop

+ (CGSize)sizeWithFont:(UIFont *)font textStr:(NSString *)textStr;
{
    return [self sizeWithFont:font maxW:MAXFLOAT textStr:(NSString *)textStr];
}

+ (BOOL)isLeapYear:(NSInteger)year
{
    NSAssert(!(year < 1), @"invalid year number");
    BOOL leap = FALSE;
    if ((0 == (year % 400))) {
        leap = TRUE;
    }
    else if((0 == (year%4)) && (0 != (year % 100))) {
        leap = TRUE;
    }
    return leap;
}

+ (NSInteger)numberOfDaysInMonth:(NSInteger)month
{
    return [GHConst numberOfDaysInMonth:month year:[GHConst getCurrentYear]];
}

+ (NSInteger)getCurrentYear
{
    time_t ct = time(NULL);
    struct tm *dt = localtime(&ct);
    int year = dt->tm_year + 1900;
    return year;
}

+ (NSInteger)getCurrentMonth
{
    time_t ct = time(NULL);
    struct tm *dt = localtime(&ct);
    int month = dt->tm_mon + 1;
    return month;
}

+ (NSInteger)getCurrentDay
{
    time_t ct = time(NULL);
    struct tm *dt = localtime(&ct);
    int day = dt->tm_mday;
    return day;
}

+ (NSInteger)getMonthWithDate:(NSDate*)date
{
    unsigned unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    NSInteger month = comps.month;
    return month;
}

+ (NSInteger)getDayWithDate:(NSDate*)date
{
    unsigned unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    NSInteger day = comps.day;
    return day;
}

+ (NSInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger) year
{
    NSAssert(!(month < 1||month > 12), @"invalid month number");
    NSAssert(!(year < 1), @"invalid year number");
    month = month - 1;
    static int daysOfMonth[12] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    NSInteger days = daysOfMonth[month];
    /*
     * feb
     */
    if (month == 1) {
        if ([GHConst isLeapYear:year]) {
            days = 29;
        }
        else {
            days = 28;
        }
    }
    return days;
}

+ (NSString *)dateSinceNowWithInterval:(NSInteger)dayInterval
{
    //    return [NSDate dateWithTimeIntervalSinceNow:dayInterval*24*60*60];
    
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:dayInterval*24*60*60];
    NSCalendar *_calendar=[NSCalendar currentCalendar];
    NSInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *com=[_calendar components:unitFlags fromDate:date];
    NSInteger currDay=[com day];  // 当前日期
    return [NSString stringWithFormat:@"%ld",currDay];
}

+ (NSDate*)dateSinceCurrentDayWithInterval:(NSInteger)dayInterval{
    
    return [NSDate dateWithTimeIntervalSinceNow:dayInterval*24*60*60];
}

+ (NSString *)getDocumentDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
/*****************************/


/********************* System Utils **********************/
+ (void)showAlertMessage:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)closeKeyboard
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

+ (NSString *)md5FromString:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/******* UITableView & UINavigationController Utils *******/
+ (UILabel *)tableViewsHeaderLabelWithMessage:(NSString *)message
{
    UILabel *lb_headTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 20)];
    lb_headTitle.font = [UIFont boldSystemFontOfSize:15.0];
    lb_headTitle.textColor = [UIColor darkGrayColor];
    lb_headTitle.textAlignment = NSTextAlignmentCenter;
    lb_headTitle.text = message;
    return lb_headTitle;
}

+ (UIView *)tableViewsFooterView
{
    UIView *coverView = [UIView new];
    coverView.backgroundColor = [UIColor clearColor];
    return coverView;
}

+ (UIBarButtonItem *)navigationBackButtonWithNoTitle
{
    return [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

/********************* SVProgressHUD **********************/
+ (void)showSuccessMessage:(NSString *)message
{
    [SVProgressHUD showSuccessWithStatus:message];
}

+ (void)showErrorMessage:(NSString *)message
{
    [SVProgressHUD showErrorWithStatus:message];
}

+ (void)showProgressMessage:(NSString *) message
{
    [SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeClear];
//    [SVProgressHUD showProgress:0.3f status:message maskType:SVProgressHUDMaskTypeGradient];
//    [SVProgressHUD showProgress:0.4f maskType:SVProgressHUDMaskTypeBlack];
//    [SVProgressHUD showSuccessWithStatus:message maskType:SVProgressHUDMaskTypeGradient];
    
//    [SVProgressHUD showWithStatus:message];
}

+ (void)dismissHUD
{
    [SVProgressHUD dismiss];
}

/********************** NSDate Utils ***********************/
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateString];
}

/********************* Category Utils **********************/
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

/********************* Verification Utils **********************/
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber{
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:phoneNumber];
    BOOL res2 = [regextestcm evaluateWithObject:phoneNumber];
    BOOL res3 = [regextestcu evaluateWithObject:phoneNumber];
    BOOL res4 = [regextestct evaluateWithObject:phoneNumber];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isEmptyString:(NSString *)str
{
    if ([str isEqualToString:@""] || str == nil || [[str class] isSubclassOfClass:[NSNull class]])
    {
        return YES;
    }else
    {
        return NO;
    }
}

/**
 *  根据名称 归档对象
 */
+ (BOOL)archiverWithFileName:(NSString*)fileName Object:(id)obj
{
    return  [NSKeyedArchiver archiveRootObject:obj toFile:[self getAbsolutePathWithFileName:fileName]];
}
/**
 *  根据名称解档对象
 */
+ (id)archiverWithFileName:(NSString*)fileName;
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self getAbsolutePathWithFileName:fileName]];
}
/**
 *   根据传过来的文件名  拼接到cache文件夹路径后 此处只传入文件名
 */
+(NSString*)getAbsolutePathWithFileName:(NSString*)fileName
{
    NSString *cache=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    NSString *filePath=[cache stringByAppendingPathComponent:fileName];
    
    filePath=[filePath stringByAppendingString:@".data"];
    return filePath;
}

+ (BOOL)deleteWithFilePath:(NSString *)fileName
{
    NSFileManager *mgr=[NSFileManager defaultManager];
    NSError *error=nil;
    //    BOOL isSuccess= [mgr removeItemAtURL:[NSURL URLWithString:[self getAbsolutePathWithFileName:fileName]] error:&error];
    BOOL isSuccess= [mgr removeItemAtPath:[self getAbsolutePathWithFileName:fileName] error:&error];
    if (error) {
        NSLog(@"%@",[error description]);
    }
    
    return isSuccess;
}

/**
 *   根据传过来的文件名  拼接到Document文件夹路径后 此处只传入文件名
 */
+(NSString*)getAbsolutePathWithDocumentFileName:(NSString*)fileName dirName:(NSString *)dirStr
{
    NSString *docPath = [self getDocumentDirectoryPath];
    
    if (dirStr && ![dirStr isEqualToString:@""])
    {
        docPath = [docPath stringByAppendingPathComponent:dirStr];
    }
    
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    
    return filePath;
}

+ (BOOL)deleteWithFileWithDocumentPath:(NSString *)fileName dirName:(NSString *)dirStr
{
    NSFileManager *mgr=[NSFileManager defaultManager];
    NSError *error=nil;
    //    BOOL isSuccess= [mgr removeItemAtURL:[NSURL URLWithString:[self getAbsolutePathWithFileName:fileName]] error:&error];
    BOOL isSuccess= [mgr removeItemAtPath:[self getAbsolutePathWithDocumentFileName:fileName dirName:dirStr] error:&error];
    if (error) {
        NSLog(@"%@",[error description]);
    }
    
    return isSuccess;
}


/********************** 获取 中文 ****************************/

static NSArray *numberUnitArr;
static NSArray *groupNumberArr;
static NSArray *numberArr;
+(void)initialize
{
    numberUnitArr=@[@"",@"十",@"百",@"千"];
    groupNumberArr=@[@"",@"万",@"亿"];
    numberArr=@[@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"];
}
/**
 *  返回数组 前后带文字
 */
+(NSArray *)getCharacterNumberArrayWithMaxNumber:(NSInteger)maxNumber prefix:(NSString *)prefix subfix:(NSString *)subfix
{
    NSMutableArray *m_arr=[NSMutableArray array];
    for (NSInteger i=1; i<=maxNumber; i++) {
        @autoreleasepool {
            NSString *str=[NSString stringWithFormat:@"%@%@%@",prefix?prefix:@"",[self getCharacterWithNumber:i],subfix?subfix:@""];
            [m_arr addObject:str];
        }
    }
    return m_arr;
}

/**
 *  返回数组
 */
+(NSArray *)getCharacterNumberArrayWithMaxNumber:(NSInteger)maxNumber
{
    NSMutableArray *m_arr=[NSMutableArray array];
    for (NSInteger i=1; i<=maxNumber; i++) {
        [m_arr addObject:[self getCharacterWithNumber:i]];
    }
    return m_arr;
}

/**
 *  获取 数字对应的 汉字  12  十二
 */
+(NSString *)getCharacterWithNumber:(NSInteger)number
{
    NSMutableString *m_str=[NSMutableString string];
    int unitNum=4;//数字都是4个一组
    NSString *str=[self getChinaNumberGroup:number];
    NSInteger count=str.length%4==0?str.length/unitNum:str.length/unitNum+1;
    
    NSInteger flag=str.length;
    
    if (str.length<=4) {
        [m_str appendString:[self getGroupCharacterWithNumberStr:str]];
    }else{
        for (int i=0; i<count; i++) {
            flag=flag-4;
            
            NSInteger loc=flag;
            NSInteger len=4;
            if (flag<0) {
                len=len+loc;
                loc=0;
            }
            
            NSString *temp=[str substringWithRange:NSMakeRange(loc, len)];
            [m_str insertString:groupNumberArr[i] atIndex:0];
            [m_str insertString:[self getGroupCharacterWithNumberStr:temp] atIndex:0];
        }
    }
    NSString *resultStr=m_str;
    resultStr=[resultStr stringByReplacingOccurrencesOfString:@"零十" withString:@"零"];
    resultStr=[resultStr stringByReplacingOccurrencesOfString:@"零百" withString:@"零"];
    resultStr=[resultStr stringByReplacingOccurrencesOfString:@"零千" withString:@"零"];
    resultStr=[resultStr stringByReplacingOccurrencesOfString:@"零万" withString:@"万"];
    resultStr=[resultStr stringByReplacingOccurrencesOfString:@"一十" withString:@"十"];
    
    NSString *result=resultStr;
    //    [result containsString:@"零零"]
    while([result rangeOfString:@"零零"].location!=NSNotFound) {
        result=[result stringByReplacingOccurrencesOfString:@"零零" withString:@"零"];
    }
    if ([result hasSuffix:@"零"]) {
        result =[result substringToIndex:result.length-1];
    }
    
    result=[result stringByReplacingOccurrencesOfString:@"零十" withString:@"零"];
    result=[result stringByReplacingOccurrencesOfString:@"零百" withString:@"零"];
    result=[result stringByReplacingOccurrencesOfString:@"零千" withString:@"零"];
    result=[result stringByReplacingOccurrencesOfString:@"零万" withString:@"万"];
    result=[result stringByReplacingOccurrencesOfString:@"一十" withString:@"十"];
    result=[result stringByReplacingOccurrencesOfString:@"亿万" withString:@"亿"];
    
    return result;
}


/**
 *  四个四个转
 */
+(NSString*)getGroupCharacterWithNumberStr:(NSString*)groupNumStr
{
    NSMutableString *m_str=[NSMutableString string];
    NSInteger count=groupNumStr.length;
    for (int i=0; i<count; i++) {
        NSString *tempStr=[groupNumStr substringWithRange:NSMakeRange(i, 1)];
        [m_str appendString:tempStr];
        [m_str appendString:numberUnitArr[count-i-1]];
    }
    
    NSString *result=m_str;
    //    [result containsString:@"零零"]
    while([result rangeOfString:@"零零"].location!=NSNotFound) {
        result=[result stringByReplacingOccurrencesOfString:@"零零" withString:@"零"];
    }
    if ([result hasSuffix:@"零"]) {
        result =[result substringToIndex:result.length-1];
    }
    return result;
}



/**
 *  123   一二三
 */
+(NSString*)getChinaNumberGroup:(NSInteger)num
{
    NSMutableString *m_str=[NSMutableString string];
    
    NSString *str=[NSString stringWithFormat:@"%zd",num];
    for (int i=0; i<str.length; i++) {
        NSRange range=NSMakeRange(i, 1);
        NSString *tempStr=[str substringWithRange:range];
        NSInteger value=[tempStr integerValue];
        [m_str appendString:numberArr[value]];
    }
    return m_str;
}

+ (BOOL)predicateAllChinese:(NSString *)textStr
{
    NSString *regex = [NSString stringWithFormat:@"^[\u4E00-\u9FA5]*$"]; // 规则
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:textStr];
}

@end

