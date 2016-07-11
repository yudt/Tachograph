//
//  AppLog.swift
//  iosNewNavi
//
//  Created by Ethan on 16/5/11.
//  Copyright © 2016年 Mapbar Inc. All rights reserved.
//

import UIKit
import CoreLocation
import Reachability

/**********************************************************
 
 /-- V0.0.1 --/
 
 使用方式：
 
 /*
    /// Objective-C 需要导入头文件  
                           -->  #import "OnlineNavigation-Swift.h"
 
    自定义内容Message参数，其他照抄
    建议拖入代码块中

    [AppLog MSGLogWithMessage:@"<#需要你填写的地方#>" functionName:[NSString stringWithCString:__func__ encoding:NSUTF8StringEncoding] fileNameWithPath:@__FILE__ lineNumber:__LINE__];

    /// Swift
 
    MSGLog(Message: "<#需要你填写的地方#>")
 */

 添加位置~：
 启动过程，重构和添加日志；重要的业务处理，UI交互需要添加；界面的切换，Controller的生命周期；大体的规则，函数进入和出去的时候。

 
**********************************************************/


#if DEBUG
    // debug 版本保存日志
    private let writeFileWithOutPut  : Bool = false
    
    // 控制台输出
    private let openLog : Bool = true
#else
    
    private let writeFileWithOutPut  : Bool = false
    private let openLog : Bool = false
    
#endif
private var filePath : String = ""
private let FILE_MAX_SIZE : CLong = (1024 * 1024 * 100)
private let infoDict : NSDictionary = NSBundle.mainBundle().infoDictionary!

func MSGLog(Message message: String,
                    functionName:  String = #function, fileNameWithPath: String = #file, lineNumber: Int = #line ) {
    
    let output : String = "\(AppLog.getTime()): \(message) [\(functionName) in \(fileNameWithPath), line \(lineNumber)] ,\(AppLog.AppLocationIsOn()),\(AppLog.AppConnect())"
    
    AppLog.write(Log: output)
}

class AppLog: NSObject {
    
    class func MSGLog(Message message: String,
                        functionName:  String = #function, fileNameWithPath: String = #file, lineNumber: Int = #line ) {
        
        let output : String = "\(getTime()): \(message) [\(functionName) in \(fileNameWithPath), line \(lineNumber)],\(AppLocationIsOn()),\(AppConnect())"
        
        AppLog.write(Log: output)
    }
    // 指定文件大小，创建文件夹以及文件
    // 初始化日志
    private class func createFilePath() -> Bool{
        
        if filePath.isEmpty {
            
            let times : String = returnTimeString(Format: "%Y%m%d%H%M%S")

            
            let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
            
            filePath =  documentPath + "/Logs"
            
            // 判断文件夹是否存在，不存在创建
            if !NSFileManager.defaultManager().fileExistsAtPath(filePath) {
                // 禁用  mkdir(String.fromCString(filePath)!, 0777)
                do {
                    
                    try NSFileManager.defaultManager().createDirectoryAtPath(filePath, withIntermediateDirectories: true, attributes: nil)
                }
                catch {
                    
                }
                
            }
            // 路径 + 文件名
            filePath += "/App_log_\(String.fromCString(times)!).txt"
            
            printLog(Log: filePath)
            
            // 初始化状态
            let FileText : String = "应用名称: \(AppDisplayName()) | [应用版本号：\(AppVersion())] \n设备名称：\(AppSystemName())\nUUID:\(AppUUID())\n设备版本号：\(AppSystemVersion())\n设备型号：\(AppModel()) [\(AppLocalizedModel())] , 电量：\(AppBatteryLevel())% - \nLocation:\(AppLocationIsOn()) , 网络状态：\(AppConnect())"

            write(Log: FileText)
            
            return true
        }
        
        return false
    }

    // 日志写入
    private class func write(Log  log : String) -> Bool{
        
        if !writeFileWithOutPut { return false }
        if log.isEmpty {
            printLog(Log: "写入数据不可为空")
            return false
        }
        
        if !filePath.isEmpty && !log.isEmpty {
         
            let length : CLong = get_file_size(FileName: filePath.cStringUsingEncoding(NSUTF8StringEncoding)!)
            // 文件超过最大限制，重新创建一份
            if length > FILE_MAX_SIZE{
                filePath = ""
                if createFilePath() {
                    printLog(Log: "日志已满，重新创建成功 \( #file ):\(#line)")
                }else{
                    printLog(Log: "文件创建失败 \( #file ):\(#line)")
                }
            }
                
            // 初始化日志
            let fp : UnsafeMutablePointer<FILE> = fopen(filePath, "at+")
            
            if fp == nil {
                printLog(Log: "File cannot be opened!")
                return false
            }
            
            if fp != nil {
                
                var end : Character = "\n"
                let cLog = log.cStringUsingEncoding(NSUTF8StringEncoding)!
                let logMaxSize = log.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) + 1
                fwrite(cLog, logMaxSize, 1, fp)
                
                fwrite(&end, 1, 1, fp)
                fwrite(&end, 1, 1, fp)
                
                fclose(fp)
                
                // 输出保存内容
                printLog(Log: log)
                
                return true
            }else{
                
                let newStr : String =  log + "\n"
                
                let  data : NSData = newStr.dataUsingEncoding(NSUTF8StringEncoding)!
                
                printLog(Log: "这样保存有问题，请查看代码")
                
                return data.writeToFile(filePath, atomically: true)
            }
                
            
        }else{
            /**
             *  没有文件名称
             */
            createFilePath()
            AppLog.write(Log: log)
        }
        
        return false
    }

}

// MARK: tools
extension AppLog{
    
    /**
     *  有选择输出Log信息
     */
    private class func printLog(Log log : NSString){
        if openLog {
            
            print("--------------------------------------------\nAPPLICATION LOG:\n\(log)\n--------------------------------------------\n")
        }
    }
    
    private class func get_file_size(FileName filename : [CChar]) -> CLong {
        
        var length : CLong = 0
        
        let fp  = fopen(String.fromCString(filename)!,"rb")
        
        if  fp != nil {
            fseek(fp, 0, SEEK_END)
            length = ftell(fp)
            
            fclose(fp)
            
            return length
        }else{
            return 0
        }
    }
    
    /**
     *  传入时间格式，传入nil为默认格式："%04d-%02d-%02d %02d:%02d:%02d"
     */
    class func returnTimeString(Format format:String?) -> String{
        
        var formatStr : String = "%04d-%02d-%02d  %02d:%02d:%02d"
        
        if let str = format where !str.isEmpty {
            formatStr = str
        }
        
        var buffer : [CChar] = Array.init(count: 32, repeatedValue: 0)
        memset(&buffer, 0, sizeofValue(buffer))
        
        var rawtime : time_t  = time_t()
        time(&rawtime)
        let timeinfo : UnsafeMutablePointer<tm> = localtime(&rawtime)
        var info : tm = timeinfo.memory
        
        if formatStr != "%04d-%02d-%02d  %02d:%02d:%02d" {
            strftime(&buffer, buffer.count , formatStr, &info)
        }else{
            buffer = String(format: formatStr,info.tm_year + 1900,info.tm_mon + 1,info.tm_mday,info.tm_mday,info.tm_hour,info.tm_min,info.tm_sec).cStringUsingEncoding(NSUTF8StringEncoding)!
        }
        
        return String.fromCString(buffer) ?? ""
    }
    
    /**
     *  精确到毫秒
     */
    private class func getTime() -> String{
        
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd 'at' HH:mm:ss.SS" //  "yyy-MM-dd 'at' HH:mm:ss.SSS"
        let str = timeFormatter.stringFromDate(date) as String
        
        return str
    }
    
    
    /**
     *  应用名称
     */
    private class func AppDisplayName() -> String {
        return "\(infoDict.valueForKey("CFBundleDisplayName", defaultValue: "没有CFBundleDisplayName"))"
    }
    
    /**
     *  应用版本号
     */
    private class func AppVersion() -> String {
        return "\(infoDict.valueForKey("CFBundleVersion", defaultValue: "没有CFBundleVersion!"))"
    }
    
    /**
     *  设备版本号
     */
    private class func AppSystemVersion() -> String {
        return UIDevice.currentDevice().systemVersion
    }
    
    /**
     *  设备名称
     */
    private class func AppSystemName() -> String {
        return UIDevice.currentDevice().systemName
    }
    
    
    /**
     * 设备唯一标识 UUID
     */
    private class func AppUUID() -> String {
        return "\(UIDevice.currentDevice().identifierForVendor!)"
    }
    
    /**
     * 设备型号
     */
    private class func AppModel() -> String {
        return UIDevice.currentDevice().model
    }
    
    /**
     * 设备区域化型号 A1533 等，能区分港版、国行、电信、联通等
     */
    private class func AppLocalizedModel() -> String {
        return UIDevice.currentDevice().localizedModel
    }
    
    /**
     *  设备电量
     */
    private class func AppBatteryLevel() -> String {
        return "\(UIDevice.currentDevice().batteryLevel * Float(100))"
    }
    
    /**
     *  定位是否开启
     */
    private class func AppLocationIsOn() -> String {
        
            if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .AuthorizedAlways || CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
                return "定位已开启"
            }else{
                return "定位未开启"
            }
    }
    
    /**
     *  当前网络状态
     */
    private class func AppConnect() -> String {
        let reachability = Reachability.reachabilityForInternetConnection()
        //判断连接类型
        if reachability.currentReachabilityStatus() == .ReachableViaWiFi
        {
            return  "WiFi"
        }else if reachability.currentReachabilityStatus() == .ReachableViaWWAN {
            return  "移动网络"
        }else {
            return  "没有网络连接"
        }
    }
    
    
}

