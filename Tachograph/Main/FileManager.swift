//
//  FileManager.swift
//  Tachograph
//
//  Created by Ethan on 16/5/23.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit

enum VideoModelStyle : Int {
    case None
    case Photo
    case Video
    case RecordingVideo
}


struct VideoModel {
    
    var creationDate : NSDate
    var ModificationDate : NSDate
    var fileSize : Int
    var type : VideoModelStyle?
    var filePath : NSString?
    var videoImage : UIImage?
    
    static func Video(dict : NSDictionary) -> VideoModel?{
        
        let model : VideoModel = VideoModel(creationDate: dict[NSFileCreationDate] as! NSDate,ModificationDate: dict[NSFileModificationDate] as! NSDate,fileSize:dict[NSFileSize] as! Int ,type:.None,filePath: nil , videoImage: nil)
        
        return model
    }
    
    
    func isVideo() ->Bool{
        return self.type == .Video
    }
    
    func isRecordingVideo() -> Bool {
        return self.type == .RecordingVideo
    }
    
    func isPhoto()-> Bool{
        return self.type == .Photo
    }
    
    mutating func setImage(image : UIImage){
        self.videoImage = image
    }
    
    mutating func setFilePath(filePath : NSString){
        self.filePath = filePath
    }
    
    mutating func setType(type : VideoModelStyle){
        self.type = type
    }
}


private let documentMoviePath : String = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! + "/Mov")
private let documentPicturePath : String = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! + "/Pic")



class FileManager: NSObject {

    
    class func createFileUrl() -> NSURL? {
        if documentMoviePath.isEmpty {
            MSGLog(Message: "路径不存在！")
            return nil
        }
        // 判断文件夹是否存在，不存在创建
        if !NSFileManager.defaultManager().fileExistsAtPath(documentMoviePath) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(documentMoviePath, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                
            }
            
        }
        
        var filePath : NSString = documentMoviePath
        // 文件名称 时间
        var nameStr : String = AppLog.returnTimeString(Format: "%Y%m%d%H%M%S")
        
        nameStr += ".mp4"
        
        filePath = filePath.stringByAppendingPathComponent(nameStr)
        
        MSGLog(Message: "保存路径为：\(filePath)")
        return NSURL.fileURLWithPath(filePath as String)

    }
    
    class func VideoModels() -> [VideoModel]? {
        
        do {
            
            let nameArr : NSArray = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(documentMoviePath)
            
            if nameArr.count > 0 {
                var items : [VideoModel] = []
                for nameString in  nameArr{
                    let filePath : String = "\(documentMoviePath)/\(nameString)"
                    do{
                        let dict : NSDictionary = try NSFileManager.defaultManager().attributesOfItemAtPath(filePath)

                        if dict.count > 0 {
                            let model : VideoModel? = VideoModel.Video(dict)
                            if var item = model {
                                let image : UIImage? = CaptureManager.getVideoImage(filePath)
                                if let aImage = image {
                                    item.setImage(aImage)
                                    item.setType(.Video)
                                    item.setFilePath(filePath)
                                    items.insert(item, atIndex: items.count)
                                }
                            }
                        }
                        
                    }catch{
                        MSGLog(Message: "catch：！！！ 路径取出信息有误")
                    }
                }
                return items
            }
            
        }catch{
            MSGLog(Message: "catch: !!! 文件名称提取失败")
        }
        
        return nil
    }
    
    // 遍历文件夹所占空间的大小
    class func folderSizeAtPath(folderPath : String) -> Float{
        if NSFileManager.defaultManager().fileExistsAtPath(folderPath) {
            return 0
        }
        
        let files = NSFileManager.defaultManager().subpathsAtPath(folderPath)
        
        var folderSize : Float = 0
        for obj in files! {
            let pathStr : NSString = "\(documentMoviePath)/\(obj)"
            folderSize += Float(fileSizeAtPaht(pathStr))
        }
        return folderSize

    }
    
    // 遍历文件大小
    class func fileSizeAtPaht(filePath : NSString) -> Int {
        if !NSFileManager.defaultManager().fileExistsAtPath(filePath as String) {
            return 0
        }
        do{
            let dict = try NSFileManager.defaultManager().attributesOfItemAtPath(filePath as String)
            return dict[NSFileSize] as! Int
        }catch{
            
        }
        return 0
    }
    
    // 手机剩余空间
    class func phoneHasFreeSpace()->NSInteger {
        var buf = statfs()
        var freespace : NSInteger = -1
        if statfs("/var",&buf) >= 0
        {
            freespace = (NSInteger)(buf.f_bsize.toUIntMax() * buf.f_bfree.toUIntMax())
            freespace = freespace / 1000 / 1000
            return freespace
            //            print("剩余录制空间为\(freespace/1024)G") // G
        }
        return 0
    }
    
    class func removeFile(outputFileUrl : NSURL){
        
        
    }
    
    class func copyFileToDocuments(fileUrl : NSURL){
        
    }
    
    class func copyFileToCameraRoll(fileUrl : NSURL){
        
    }
    
}
